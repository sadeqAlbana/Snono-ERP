#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
ProductsModel::ProductsModel(QObject *parent) : NetworkedJsonModel ("/products",parent)
{
    requestData();
}


void ProductsModel::requestData()
{
    manager.get(url)->subcribe((NetworkedJsonModel *)this,&NetworkedJsonModel::onTableRecieved);
}

ColumnList ProductsModel::columns() const
{
    return ColumnList() <<
                           Column{"id","ID"} <<
                           Column{"name","Name"} <<
                           Column{"barcode","Barcode"} <<
                           Column{"default_cost","Default Cost"} <<
                           Column{"qty","Stock","products_stocks"} <<
                           Column{"list_price","List Price"};
}
