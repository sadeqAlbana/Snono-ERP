#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
#include <posnetworkmanager.h>
ProductsModel::ProductsModel(QObject *parent) : AppNetworkedJsonModel ("/products",ColumnList() <<
                                                                                                   Column{"id","ID"} <<
                                                                                                   Column{"name","Name"} <<
                                                                                                   Column{"barcode","Barcode"} <<
                                                                                                   Column{"cost","Cost"} <<
                                                                                                   Column{"qty","Stock","products_stocks"} <<
                                                                                                   Column{"list_price","List Price"},parent)
{
    requestData();
}




void ProductsModel::updateProduct(const QJsonObject &product)
{
    PosNetworkManager::instance()->post("/products/update",product)->subcribe(this,&ProductsModel::onUpdateProductReply);
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
    QJsonObject product=jsonObject(index);
    QJsonObject params;
    params["product_id"]=product["id"];
    params["new_quantity"]=newQuantity;
    PosNetworkManager::instance()->post("/products/updateQuantity",params)->subcribe(this,&ProductsModel::onUpdateProductQuantityReply);
}

void ProductsModel::onUpdateProductQuantityReply(NetworkResponse *res)
{
    emit productQuantityUpdated(res->json().toObject());
}

void ProductsModel::purchaseStock(const int &productId, const double &qty)
{
    QJsonObject params;
    params["product_id"]=productId;
    params["qty"]=qty;
    PosNetworkManager::instance()->post("/products/purchaseProduct",params)->subcribe(this,&ProductsModel::onPurchaseStockReply);

}

void ProductsModel::onPurchaseStockReply(NetworkResponse *res)
{
    emit stockPurchasedReply(res->json().toObject());
}

void ProductsModel::addProduct(const QString &name, const QString &barcode, const double &listPrice, const double &cost, const int &typeId, const QString &description, const int &categoryId, const QJsonArray &taxes)
{
    qDebug()<<taxes;
    QJsonObject params{
        {"name",name},
        {"barcode",barcode},
        {"list_price",listPrice},
        {"cost",cost},
        {"type",typeId},
        {"description",description},
        {"taxes",taxes},
        {"category_id",categoryId}
    };

    PosNetworkManager::instance()->post("/products/add",params)->subcribe([this](NetworkResponse *res){
        emit productAddReply(res->json().toObject());
    });
}

void ProductsModel::removeProduct(const int &productId)
{
    PosNetworkManager::instance()->post("/products/remove",QJsonObject{{"id",productId}})
            ->subcribe([this](NetworkResponse *res){
        emit productRemoveReply(res->json().toObject());
    });
}
