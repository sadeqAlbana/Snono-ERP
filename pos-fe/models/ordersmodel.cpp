#include "ordersmodel.h"

OrdersModel::OrdersModel(QObject *parent) : NetworkedJsonModel("/orders",parent)
{
    requestData();
}

ColumnList OrdersModel::columns() const
{
    return ColumnList() <<
                           Column{"id","ID"} <<
                           Column{"name","Customer","customers"} <<
                           Column{"reference","Reference"} <<
                           Column{"total","Total"} <<
                           Column{"date","Date"} <<
                           Column{"tax_amount","Tax Amount"};
}
