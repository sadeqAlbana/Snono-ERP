#include "receiptmodel.h"
#include "../posnetworkmanager.h"
ReceiptModel::ReceiptModel(QObject *parent) : AppNetworkedJsonModel ("/order",{
                                                                     Column{"name",tr("Description"),"products"} ,
                                                                     Column{"unit_price",tr("Price"),QString(),"currency"} ,
                                                                     Column{"qty",tr("Qty")} ,
                                                                     Column{"subtotal",tr("Subtotal"),QString(),"currency"},
                                                                     Column{"total",tr("Total"),QString(),"currency"}
                                                                     },parent),m_orderId(2)
{

}
void ReceiptModel::requestData()
{
    PosNetworkManager::instance()->post(url(),QJsonObject{
                                            {"order_id",m_orderId}})->subcribe(this,&ReceiptModel::onTableRecieved);
}



void ReceiptModel::onTableRecieved(NetworkResponse *reply)
{
    //setCartData(reply->json().toObject()["cart"].toObject());
    m_orderData=reply->json("order").toObject();
    setupData(reply->json("order").toObject()["pos_order_items"].toArray());
    //qDebug()<<reply->json("order").toObject();
    emit dataReceived();
    emit totalChanged(total());
    emit taxAmountChanged(taxAmount());
    emit referenceChanged(reference());
    emit customerChanged(customer());
    emit addressChanged(address());
    emit phoneChanged(phone());
    emit dateChanged(date());


    //emit totalChanged(cartData()["order_total"].toDouble());
}

double ReceiptModel::total()
{
    return m_orderData["total"].toDouble();
}

double ReceiptModel::taxAmount()
{
    return m_orderData["tax_amount"].toDouble();

}

QString ReceiptModel::reference()
{
    return m_orderData["reference"].toString();
}

QString ReceiptModel::customer()
{
    return m_orderData["customers"].toObject()["first_name"].toString();

}

QString ReceiptModel::address()
{
    return m_orderData["customers"].toObject()["address"].toString();

}

QString ReceiptModel::phone()
{
    return m_orderData["customers"].toObject()["phone"].toString();

}

QString ReceiptModel::date()
{
    return m_orderData["date"].toString();

}
