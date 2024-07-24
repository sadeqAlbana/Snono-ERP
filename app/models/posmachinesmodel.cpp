#include "posmachinesmodel.h"

PosMachinesModel::PosMachinesModel(QObject *parent) : AppNetworkedJsonModel("/postmachines",{
                                              {"id",tr("ID")} ,
                                              {"hw_id",tr("Hardware ID")} ,
                                              {"ip_address",tr("IP Address")} ,
                                              {"account_id",tr("Account ID")} ,
                                              {"enabled",tr("Enabled"),QString(),false},
                                              {"created_at",tr("Created At"),QString(),false}

                                             },
                            parent)
{

}
