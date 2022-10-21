#include "ordersmodel.h"
#include "../posnetworkmanager.h"
OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",{
                                                                  {"id",tr("ID")} ,
                                                                  {"reference",tr("Reference")} ,
                                                                  {"name",tr("Customer"),"customers"} ,
                                                                  {"phone",tr("Phone"),"customers"} ,
                                                                  {"address",tr("Address"),"customers"} ,
                                                                  {"total",tr("Total"),QString(),"currency"} ,
                                                                  {"date",tr("Date"),QString(),"datetime"} ,
                                                                  //{"tax_amount",tr("Tax Amount"),QString(),"currency"},
                                                                  {"delivery_status",tr("Status"),QString(),"OrderStatus"} ,
                                                                  {"external_delivery_id",tr("Delivery Id"),QString()} ,
                                                                  {"external_delivery_status",tr("Delivery Status"),QString(),"externalDeliveryStatus"} ,

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


QJsonArray OrdersModel::filterData(QJsonArray data)
{
    QStringList wanted{"external_delivery_id","external_delivery_receipt","external_delivery_status"};
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        QJsonArray attributes=product["attributes"].toArray();

        for(int j=0; j<attributes.size(); j++){
            QJsonObject attribute=attributes.at(j).toObject();
            QString attributeId=attribute["id"].toString();
            if(wanted.contains(attributeId)){
                product[attributeId]=attribute["value"];
            }
        }
        data.replace(i,product);
    }
    return data;
}

