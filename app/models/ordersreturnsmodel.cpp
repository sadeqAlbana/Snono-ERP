#include "ordersreturnsmodel.h"

OrdersReturnsModel::OrdersReturnsModel(QObject *parent) : AppNetworkedJsonModel("/orders/returns",{
//                                                                                {"name","Customer","customers"} ,
                                                                                {"reference",tr("Order Reference"),"order"} ,
                                                                                {"total",tr("Total"),QString(),"currency"} ,
                                                                                {"date",tr("Date"),QString(),"datetime"} ,
                                                                                {"tax_amount",tr("Tax Amount"),QString(),"currency"}
                                                                                },
                                                                                parent)
{
   requestData();
}
