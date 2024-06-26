#include "possessionsmodel.h"


PosSessionsModel::PosSessionsModel(QObject *parent) : AppNetworkedJsonModel("/posssessions",{
                                                 {"id",tr("ID")} ,
                                                 {"state",tr("State"),QString(),false,"SessionStatus"} ,
                                                 {"username",tr("User"),"user"} ,
                                                 {"id",tr("Machine"),"machine"} ,
                                                 {"orders_count",tr("Orders Count")} ,
                                                 {"orders_total",tr("Total"),QString(),false,"currency"} ,
                                                 {"created_at",tr("Created"),QString(),false,"datetime"} ,
                                                 {"closed_at",tr("Closed At"),QString(),false,"datetime"}},
                            parent)
{

}
