#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
ProductsModel::ProductsModel(QObject *parent) : NetworkedJsonModel ("/products",parent)
{
    requestData();
}



ColumnList ProductsModel::columns() const
{
    return ColumnList() <<
                           Column{"id","ID"} <<
                           Column{"name","Name"} <<
                           Column{"barcode","Barcode"} <<
                           Column{"cost","Cost"} <<
                           Column{"qty","Stock","products_stocks"} <<
                           Column{"list_price","List Price"};
}

void ProductsModel::updateProduct(const QJsonObject &product)
{
    manager.post("/products/update",product)->subcribe(this,&ProductsModel::onUpdateProductReply);
}

void ProductsModel::onUpdateProductReply(NetworkResponse *res)
{
    QJsonObject response=res->json().toObject();
    if(response["status"].toBool())
        this->requestData();

    emit productUpdateReply(response);
}
