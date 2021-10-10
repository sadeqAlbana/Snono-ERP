#include "ordersmodel.h"

OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",{
                                                                  Column{"id","ID"} ,
                                                                  Column{"name","Customer","customers"} ,
                                                                  Column{"reference","Reference"} ,
                                                                  Column{"total","Total",QString(),"currency"} ,
                                                                  Column{"date","Date"} ,
                                                                  Column{"tax_amount","Tax Amount",QString(),"currency"}},parent)
{
    requestData();

}

