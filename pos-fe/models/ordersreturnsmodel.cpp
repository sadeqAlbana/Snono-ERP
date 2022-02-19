#include "ordersreturnsmodel.h"

OrdersReturnsModel::OrdersReturnsModel(QObject *parent) : AppNetworkedJsonModel("/orders/returns",{
                                                                                Column{"name","Customer","customers"} ,
                                                                                Column{"reference","Order Reference","order"} ,
                                                                                Column{"total","Total",QString(),"currency"} ,
                                                                                Column{"date","Date"} ,
                                                                                Column{"tax_amount","Tax Amount",QString(),"currency"}
                                                                                },
                                                                                parent)
{

}
