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

void ProductsModel::updateProductQuantity(const int &index, const double &newQuantity)
{
    QJsonObject product=data(index);
    QJsonObject params;
    params["product_id"]=product["id"];
    params["new_quantity"]=newQuantity;
    manager.post("/products/updateQuantity",params)->subcribe(this,&ProductsModel::onUpdateProductQuantityReply);
}

void ProductsModel::onUpdateProductQuantityReply(NetworkResponse *res)
{
    emit productQuantityUpdated(res->json().toObject());
}

void ProductsModel::purchaseStock(const int &index, const double &qty)
{
    QJsonObject product=data(index);
    QJsonObject params;
    params["product_id"]=product["id"];
    params["qty"]=qty;
    manager.post("/products/purchaseProduct",params)->subcribe(this,&ProductsModel::onPurchaseStockReply);

}

void ProductsModel::onPurchaseStockReply(NetworkResponse *res)
{
    emit stockPurchased(res->json().toObject());
}
