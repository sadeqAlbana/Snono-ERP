#include "ordersmodel.h"
#include "posnetworkmanager.h"
OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",{
                                                                  Column{"id","ID"} ,
                                                                  Column{"name","Customer","customers"} ,
                                                                  Column{"reference","Reference"} ,
                                                                  Column{"total","Total",QString(),"currency"} ,
                                                                  Column{"date","Date"} ,
                                                                  Column{"tax_amount","Tax Amount",QString(),"currency"},
                                                                  Column{"delivery_status","Status",QString(),"OrderStatus"} ,

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

