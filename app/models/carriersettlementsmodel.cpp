#include "carriersettlementsmodel.h"


CarrierSettlementsModel::CarrierSettlementsModel(QObject *parent) : AppNetworkedJsonModel("/shipments/carriers/settlements",{
                                            {"id",tr("ID")},
                                            {"name",tr("Name"),"carrier"},
                                            {"date",tr("Date"),QString(),false,"datetime"} ,
                                            {"total_fees",tr("Total fees"),QString(),false,"currency"} ,
                                             {"net_total",tr("Net Total"),QString(),false,"currency"} ,
                                            {"name",tr("Payment Method"),"payment"} ,

                                                               },
                            parent)
{

}
