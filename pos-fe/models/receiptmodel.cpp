#include "receiptmodel.h"
#include "posnetworkmanager.h"
ReceiptModel::ReceiptModel(const int &orderId,QObject *parent) : AppNetworkedJsonModel ("/order",{
                                                                     Column{"id","ID"} ,
                                                                     Column{"name","Name"} ,
                                                                     Column{"type","Type",QString(),"taxType"} ,
                                                                     Column{"value","Value"} ,
                                                                     Column{"account_id","Account ID"}
                                                                     },parent),m_orderId(orderId)
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

    emit dataRecevied();
    //emit totalChanged(cartData()["order_total"].toDouble());
}
