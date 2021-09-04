#include "ordersmodel.h"

OrdersModel::OrdersModel(QObject *parent) : AppNetworkedJsonModel("/orders",ColumnList() <<
                                                                                            Column{"id","ID"} <<
                                                                                            Column{"name","Customer","customers"} <<
                                                                                            Column{"reference","Reference"} <<
                                                                                            Column{"total","Total"} <<
                                                                                            Column{"date","Date"} <<
                                                                                            Column{"tax_amount","Tax Amount"},parent)
{
    requestData();

}

