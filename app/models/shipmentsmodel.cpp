#include "shipmentsmodel.h"


ShipmentsModel::ShipmentsModel(QObject *parent)
    : AppNetworkedJsonModel{"/shipments",
                            {{"id",tr("ID")},
                            {"name",tr("Carrier"),"carrier"},
                            {"username",tr("Driver"),"driver.user"},
                             {"phone",tr("Phone"),"dst_address"} ,
                             {"district",tr("Address"),"dst_address"} ,
                             {"status",tr("Status"),QString(),false,"ShipmentStatus"},
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
