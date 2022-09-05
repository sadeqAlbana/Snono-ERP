#include "ordersmodel.h"
#include "posnetworkmanager.h"
OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",{
                                                                  Column{"id",tr("ID")} ,
                                                                  Column{"reference",tr("Reference")} ,
                                                                  Column{"name",tr("Customer"),"customers"} ,
                                                                  Column{"phone",tr("Phone"),"customers"} ,
                                                                  Column{"address",tr("Address"),"customers"} ,
                                                                  Column{"total",tr("Total"),QString(),"currency"} ,
                                                                  Column{"date",tr("Date"),QString(),"datetime"} ,
                                                                  //Column{"tax_amount",tr("Tax Amount"),QString(),"currency"},
                                                                  Column{"delivery_status",tr("Status"),QString(),"OrderStatus"} ,

                                                                  },
                                                                  parent)
{
    requestData();

}

void OrdersModel::updateDeliveryStatus(const int &orderId, const QString &status)
{
    PosNetworkManager::instance()->post("/order/updateDeliveryStatus",
                            QJsonObject{{"order_id",orderId},{"status",status}})
            ->subcribe([this](NetworkResponse *res){
            emit updateDeliveryStatusResponse(res->json().toObject());
    });
}

void OrdersModel::returnOrder(const int &orderId, const QJsonArray items)
{
    QJsonObject params;
    params["order_id"]=orderId;
    params["items"]=items;
    PosNetworkManager::instance()->post("/orders/return",params)->subcribe([this](NetworkResponse *res){

        emit returnOrderResponse(res->json().toObject());
    });
}

void OrdersModel::returnableItems(const int &orderId)
{
    QJsonObject params;
    params["order_id"]=orderId;
    PosNetworkManager::instance()->post("/order/returnableItems",params)->subcribe([this](NetworkResponse *res){

        emit returnableItemsResponse(res->json().toObject());
    });
}

