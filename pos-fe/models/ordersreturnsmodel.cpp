#include "ordersreturnsmodel.h"

OrdersReturnsModel::OrdersReturnsModel(QObject *parent) : AppNetworkedJsonModel("/orders/returns",{
//                                                                                Column{"name","Customer","customers"} ,
                                                                                Column{"reference",tr("Order Reference"),"order"} ,
                                                                                Column{"total",tr("Total"),QString(),"currency"} ,
                                                                                Column{"date",tr("Date"),QString(),"datetime"} ,
                                                                                Column{"tax_amount",tr("Tax Amount"),QString(),"currency"}
                                                                                },
                                                                                parent)
{
   requestData();
}
