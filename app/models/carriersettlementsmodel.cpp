#include "carriersettlementsmodel.h"


CarrierSettlementsModel::CarrierSettlementsModel(QObject *parent) : AppNetworkedJsonModel("/shipments/carriers/settlements",{
                                            {"id",tr("ID")},
                                            {"name",tr("Name")},
                                            {"parent_id",tr("Parent")}},
                            parent)
