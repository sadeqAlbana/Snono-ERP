#include "driversmodel.h"


DriversModel::DriversModel(QObject *parent) : AppNetworkedJsonModel ("/drivers",{
                                           {"id",tr("ID")} ,
                                           {"name",tr("Name")} ,
                                           {"user_id",tr("User ID")},
                                           {"unsettled_amount",tr("Unsettled Amount")}

                                        }
                            ,parent)
{
}
