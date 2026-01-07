#include "driversmodel.h"


DriversModel::DriversModel(QObject *parent) : AppNetworkedJsonModel ("/drivers",{
                                           {"id",tr("ID")} ,
                                           {"username",tr("Name"),"user"} ,
                                           {"account_id",tr("Account ID")},
                                           {"user_id",tr("User ID")},
                                           {"unsettled_amount",tr("Unsettled Amount")}

                                        }
                            ,parent)
{
}
