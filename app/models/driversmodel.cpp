#include "driversmodel.h"


DriversModel::DriversModel(QObject *parent) : AppNetworkedJsonModel ("/drivers",{
                                           {"id",tr("ID")} ,
                                           {"name",tr("Name")} ,
                                           {"user_id",tr("User ID")},
                                           // net COD the driver has collected but not yet settled (paid_cod − driver_fee
                                           // over their unsettled shipments); computed server-side in DriversController::index
                                           {"unsettled_amount",tr("Amount Owed"),QString(),false,"currency"}

                                        }
                            ,parent)
{
}
