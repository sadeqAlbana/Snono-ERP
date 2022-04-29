#include "cashiermodel.h"
#include <QMessageBox>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonObject>
#include <QLocale>
#include <QTextDocument>
//#include <QPrinter>
#include <QFile>
//#include "messageservice.h"
#include  "posnetworkmanager.h"
CashierModel::CashierModel(QObject *parent)
    : NetworkedJsonModel("/pos/cart/getCart",{
                         Column{"name","Name"} ,
                         Column{"thumb","Image",QString(),"image"} ,
                         Column{"unit_price","Price",QString(),"currency"} ,
                         Column{"qty","Qty"} ,
                         Column{"discount","Discount",QString(),"percentage"} ,
                         Column{"subtotal","Subtotal",QString(),"currency"} ,
                         Column{"total","Total",QString(),"currency"}},parent)
{
    //setReference("{ef624717-4436-4555-ab41-7a0b3ba4b16e}");
    requestCart();
    //requestData();

}

void CashierModel::requestData()
{
    PosNetworkManager::instance()->post(url(),QJsonObject{
                                            {"reference",reference()}})->subcribe(this,&CashierModel::onTableRecieved);
}



void CashierModel::onTableRecieved(NetworkResponse *reply)
{
    setCartData(reply->json().toObject()["cart"].toObject());

    emit dataRecevied();
    emit totalChanged(cartData()["order_total"].toDouble());
}

bool CashierModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!index.isValid())
        return false;

    if(index.row() >= rowCount() || index.column() >= columnCount() || role!=Qt::EditRole)
        return false;

    QJsonObject product=jsonObject(index.row());


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
    PosNetworkManager::instance()->post("/pos/cart/updateProduct",product)->subcribe(this,&CashierModel::onDataChange);

    return true;
}

void CashierModel::onDataChange(NetworkResponse *res)
{
    if(res->json("status").toInt()==200)
        refresh();
    else{
        //MessageService::warning("Error",res->json("message").toString());
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
    //qDebug()<<cartData;
    QJsonArray data=filterData(cartData["products"].toArray());
    setupData(data);
    emit totalChanged(this->cartData()["order_total"].toDouble());
}

QString CashierModel::reference() const
{
    return _reference;
}

void CashierModel::setReference(const QString &reference)
{
    _reference = reference;
}



void CashierModel::updateCustomer(const int &customerId)
{
    PosNetworkManager::instance()->post("/pos/cart/updateCartCustomer",
                                        QJsonObject{{"reference"  ,reference()},
                                                    {"customer_id",customerId}})->subcribe(this,&CashierModel::onUpadteCustomerReply);
}

int CashierModel::customerId() const
{
    return cartData()["customer_id"].toInt();
}

void CashierModel::addProduct(const QJsonValue &id, bool findByBarcode)
{
    PosNetworkManager::instance()->post("/pos/cart/addProduct",QJsonObject{{"reference",reference()},
                                                                           {"id",id},
                                                                           {"find_by_barcode",findByBarcode}})->subcribe(this,&CashierModel::onAddProductReply);
}



void CashierModel::onAddProductReply(NetworkResponse *res)
{
    emit addProductReply(res->json().toObject());
    if(res->json("status").toInt()==200)
        refresh();
}

void CashierModel::removeProduct(const int &index)
{
    PosNetworkManager::instance()->post("/pos/cart/removeProduct",QJsonObject{{"reference",reference()},
                                                                              {"index",index}})->subcribe(this,&CashierModel::onRemoveProductReply);
}

void CashierModel::onRemoveProductReply(NetworkResponse *res)
{
    if(res->json("status").toInt()==200){
        refresh();
    }else{

        //MessageService::warning("Error",res->json("message").toString());
    }
}

void CashierModel::processCart(const double paid, const double change, const QString &note)
{
    QJsonObject data{{"paid",paid},
                     {"returned",change},
                     {"note",note},
                     {"cart",cartData()}};
    PosNetworkManager::instance()->post("/pos/purchase",data)->subcribe(this,&CashierModel::onProcessCartRespnse);
}

void CashierModel::onProcessCartRespnse(NetworkResponse *res)
{
    emit purchaseResponseReceived(res->json().toObject());
}

void CashierModel::requestCart()
{
    PosNetworkManager::instance()->get("/pos/cart/request")->subcribe(this,&CashierModel::onRequestCartResponse);
}

void CashierModel::onRequestCartResponse(NetworkResponse *res)
{
    QJsonObject cartData=res->json("cart").toObject();
    setReference(cartData.value("reference").toString());
    setCartData(cartData);
}

void CashierModel::onUpadteCustomerReply(NetworkResponse *res)
{
    if(res->json("status").toInt()==200){
        qDebug()<<"updating customer";
        setCartData(res->json("cart").toObject());
    }
    emit updateCustomerResponseReceived(res->json().toObject());

}

QJsonArray CashierModel::filterData(QJsonArray data)
{
    QStringList wanted{"thumb","size","sku","external_sku"};
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        QJsonArray attributes=product["attributes"].toArray();

        for(int j=0; j<attributes.size(); j++){
            QJsonObject attribute=attributes.at(j).toObject();
            QString attributeId=attribute["attribute_id"].toString();
            if(wanted.contains(attributeId)){
                product[attributeId]=attribute["value"];
            }
        }
        data.replace(i,product);
    }
    return data;
}

