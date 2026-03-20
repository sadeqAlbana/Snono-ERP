#include "shipmentcarriersmodel.h"


ShipmentCarriersModel::ShipmentCarriersModel(QObject *parent)
    : AppNetworkedJsonModel{"/shipments/carriers",
                            {{"id",tr("ID")},
                            {"name",tr("Name")}
                            },
                            parent}
{
}
