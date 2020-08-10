#include "cashiermodel.h"
#include <QMessageBox>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonObject>
#include <QLocale>
#include <QTextDocument>
#include <QPrinter>
#include <QFile>
#include "messageservice.h"
CashierModel::CashierModel(QObject *parent)
    : NetworkedJsonModel("/pos/cart/getCart",parent)
{
    setReference("{573888a9-758f-4138-8162-423a5556ae04}");

}

void CashierModel::requestData()
{
    manager.post(url,QJsonObject{
                     {"reference",reference()}})->subcribe(this,&CashierModel::onTableRecieved);
}

ColumnList CashierModel::columns() const
{
    return ColumnList() <<
                           Column{"name","Name"} <<
                           Column{"unit_price","Price"} <<
                           Column{"qty","Qty"} <<
                           Column{"subtotal","Subtotal"} <<
                           Column{"total","Total"};
}

void CashierModel::onTableRecieved(NetworkResponse *reply)
{
    setCartData(reply->json().toObject()["cart"].toObject());

    emit dataRecevied();
}

bool CashierModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!index.isValid())
        return false;

    if(index.row() >= rowCount() || index.column() >= columnCount() || role!=Qt::EditRole)
        return false;

    QJsonObject product=data(index.row());

    Column column=columns().at(index.column());
    switch (static_cast<QMetaType::Type>(value.type())) {
    case QMetaType::Double     :product[column.key]=value.toDouble();    break;
    case QMetaType::QString    :product[column.key]=value.toString();    break;
    case QMetaType::Int        :product[column.key]=value.toInt();       break;
    case QMetaType::QJsonValue : product[column.key]=value.toJsonValue();break;
    default: break;
    }

    product["index"]=index.row();
    product["reference"]=_cartData["reference"];
    manager.post("/pos/cart/updateProduct",product)->subcribe(this,&CashierModel::onDataChange);

    return true;
}

void CashierModel::onDataChange(NetworkResponse *res)
{
    if(res->json("status").toBool()==true)
        refresh();
    else{
        MessageService::warning("Error",res->json("message").toString());
    }
}

double CashierModel::total()
{
    return cartData()["order_total"].toDouble();
}

double CashierModel::taxAmount()
{
    return cartData()["tax_amount"].toDouble();
}

QString CashierModel::totalCurrencyString()
{
    QLocale locale(QLocale::Arabic,QLocale::ArabicScript,QLocale::Iraq);

    return QLocale(QLocale::English,QLocale::ArabicScript,QLocale::Iraq).toCurrencyString(total(),locale.currencySymbol(QLocale::CurrencySymbol),0);
}

QString CashierModel::taxAmountCurrencyString()
{
    QLocale locale(QLocale::Arabic,QLocale::ArabicScript,QLocale::Iraq);

    return QLocale(QLocale::English,QLocale::ArabicScript,QLocale::Iraq).toCurrencyString(taxAmount(),locale.currencySymbol(QLocale::CurrencySymbol),0);
}

QJsonObject CashierModel::cartData() const
{
    return _cartData;
}

void CashierModel::setCartData(const QJsonObject &cartData)
{
    _cartData = cartData;
   setupData(cartData["products"].toArray());
}

QString CashierModel::reference() const
{
    return _reference;
}

void CashierModel::setReference(const QString &reference)
{
    _reference = reference;
}

void CashierModel::updatedCustomer(const int &customerId)
{
    manager.post("/pos/cart/updateCartCustomer",
                 QJsonObject{{"reference"  ,reference()},
                             {"customer_id",customerId}})->subcribe(this,&CashierModel::onUpadteCustomerReply);
}

int CashierModel::customerId() const
{
    return cartData()["customer_id"].toInt();
}

void CashierModel::addProduct(const QString &barcode)
{
    manager.post("/pos/cart/addProduct",QJsonObject{{"reference",reference()},
                                                    {"id",barcode},
                                                    {"find_by_barcode",true}})->subcribe(this,&CashierModel::onAddProductReply);
}

void CashierModel::onAddProductReply(NetworkResponse *res)
{
    if(res->json("status").toBool()==true){
        refresh();
    }else{
        MessageService::warning("Error",res->json("message").toString());
    }
}

void CashierModel::removeProduct(const int &index)
{
    manager.post("/pos/cart/removeProduct",QJsonObject{{"reference",reference()},
                                                    {"index",index}})->subcribe(this,&CashierModel::onRemoveProductReply);
}

void CashierModel::onRemoveProductReply(NetworkResponse *res)
{
    if(res->json("status").toBool()==true){
        refresh();
    }else{

        MessageService::warning("Error",res->json("message").toString());
    }
}

void CashierModel::processCart(const double paid, const double change)
{
    QJsonObject data{{"paid",paid},
                     {"returned",change},
                     {"cart",cartData()}};
    manager.post("/pos/purchase",data)->subcribe(this,&CashierModel::onProcessCartRespnse);
}

void CashierModel::onProcessCartRespnse(NetworkResponse *res)
{
    emit purchaseResponseReceived(res->json().toObject());
    requestCart();
}

void CashierModel::requestCart()
{
    manager.get("/pos/cart/request")->subcribe(this,&CashierModel::onRequestCartResponse);
}

void CashierModel::onRequestCartResponse(NetworkResponse *res)
{
    setReference(res->json("reference").toString());
    setCartData(res->json().toObject());
}

void CashierModel::onUpadteCustomerReply(NetworkResponse *res)
{
    emit updateCustomerReplyReceived(res->json().toObject());
}
