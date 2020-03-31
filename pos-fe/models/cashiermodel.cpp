#include "cashiermodel.h"
#include <QMessageBox>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonObject>
#include <QLocale>
CashierModel::CashierModel(QObject *parent)
    : NetworkedJsonModel("/pos/cart/getCart",parent)
{
    setReference("{d51e5c34-6f7e-4f96-a128-abb4d9711c3a}");
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
    _cartData=reply->json().toObject()["cart"].toObject();
    setupData(_cartData["products"].toArray());
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
        QMessageBox::warning((QWidget*)this->parent(),"Error",res->json("message").toString());
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
}

QString CashierModel::reference() const
{
    return _reference;
}

void CashierModel::setReference(const QString &reference)
{
    _reference = reference;
}
