#include "ordersmodel.h"
#include "../posnetworkmanager.h"
#include "networkresponse.h"
#include <networkresponse.h>
#include "utils.h"
OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",{
                                                                  {"id",tr("ID")} ,
                                                                  // {"reference",tr("Reference")} ,
                                                                  {"name",tr("Customer"),"customers",false,"link",
                                            QVariantMap{{"link","qrc:/PosFe/qml/pages/customers/CustomerForm.qml"},
                                                    {"linkKey","customer_id"}}},
                                                                  {"phone",tr("Phone"),"customers"} ,
                                                                  {"address",tr("Address"),"customers"} ,
                                                                  {"total",tr("Total"),QString(),false,"currency"} ,
                                                                  {"date",tr("Date"),QString(),false,"datetime"} ,
                                                                  //{"tax_amount",tr("Tax Amount"),QString(),false,"currency"},
                                                                  {"status",tr("Status"),QString(),false,"OrderStatus"} ,
                                                                  {"external_delivery_id",tr("Delivery Id"),QString()} ,
                                                                  {"external_delivery_status",tr("Delivery Status"),QString(),false,"externalDeliveryStatus"} ,

                                                                  },
                                                                  parent)
{
    //requestData();
}

void OrdersModel::updateDeliveryStatus(const int &orderId, const QString &status)
{
    PosNetworkManager::instance()->post(QUrl("/order/updateDeliveryStatus"),
                            QJsonObject{{"order_id",orderId},{"status",status}})
            ->subscribe([this](NetworkResponse *res){
            emit updateDeliveryStatusResponse(res->json().toObject());
    });
}

void OrdersModel::returnOrder(const int &orderId, const QJsonArray items)
{
    QJsonObject params;
    params["order_id"]=orderId;
    params["items"]=items;
    PosNetworkManager::instance()->post(QUrl("/orders/return"),params)->subscribe([this](NetworkResponse *res){

        emit returnOrderResponse(res->json().toObject());
    });
}

void OrdersModel::returnableItems(const int &orderId)
{
    QJsonObject params;
    params["order_id"]=orderId;
    PosNetworkManager::instance()->post(QUrl("/order/returnableItems"),params)->subscribe([this](NetworkResponse *res){

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

void OrdersModel::print()
{
    QJsonArray data=this->m_records;
    int total=0;
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        product.remove("phone");
        product.remove("created_at");
        product.remove("updated_at");
        product.remove("deleted_at");
        product.remove("created_at");
        product.remove("customer");
        product.remove("address");

        // product["customer"]=product["customers"].toObject()["name"];
        // product["address"]=product["customers"].toObject()["address"];
        total+=product["total"].toInt();
        data.replace(i,product);
    }

    data.append(QJsonObject{{"reference","total"},
        // {"customer",""},
        // {"address",""},
        {"date",""},
                            {"total",QString::number(total)}

    });

    QString range=QStringLiteral("All time");
    QString from;
    QString to;
    if(m_filter.contains("from")){
        from=m_filter.value("from").toString();
    }
    if(m_filter.contains("to")){
        to=m_filter.value("to").toString();
    }


    range=QString("%1 - %2").arg(from,to);

    Json::printJson(QString("Orders Report for period %1").arg(range),data,{{"reference","Reference"},
                                            // {"customer","Customer"},
//                                            {"address","Address"},
                                            {"date","Date"},
                                            {"total","Total"}

                                           });
}

