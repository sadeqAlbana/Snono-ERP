#include "shipmentsmodel.h"


ShipmentsModel::ShipmentsModel(QObject *parent)
    : AppNetworkedJsonModel{"/shipments",
                            {{"id",tr("ID")},
                            {"name",tr("Carrier"),"carrier"},
                            {"username",tr("Driver"),"driver.user"},
                             {"first_name",tr("Recipient"),"dst_address"} ,
                             {"phone",tr("Phone"),"dst_address"} ,
                             {"district",tr("Address"),"dst_address"} ,
                             {"date",tr("Date"),QString(),false,"datetime"} ,
                             {"status",tr("Status"),QString(),false,"ShipmentStatus"},
                             {"third_party_carrier_shipment_status",tr("3rd Party Status"),QString(),
                              false,"externalDeliveryStatus"} ,
                            {"notes",tr("Notes")}

                            },


                            parent}
{
}



QVariant ShipmentsModel::data(const QModelIndex &index, int role) const
{
    auto key = m_columns.value(index.column());
    if(key.m_key=="district" && role==Qt::DisplayRole){
        QJsonObject record=jsonObject(index.row()).value("dst_address").toObject();
        return QString("%1 - %2").arg(record.value("province").toString(),record.value("district").toString());
    }

    return AppNetworkedJsonModel::data(index,role);
}

QJsonObject ShipmentsModel::findShipment(const int id)
{
    for(int i=0; i<rowCount(); i++){
        int value=JsonModel::data(i,"id").toInt();
        if(value==id){
            return records().at(i).toObject();
        }
    }
    return QJsonObject();
}
