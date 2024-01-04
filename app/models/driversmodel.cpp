#include "driversmodel.h"


DriversModel::DriversModel(QObject *parent) : AppNetworkedJsonModel ("/drivers",{
                                           {"id",tr("ID")} ,
                                           {"name",tr("Name")} ,
                                           {"account_id",tr("Account ID")},
                                           {"user_id",tr("User ID")}}
                            ,parent)
{
}
