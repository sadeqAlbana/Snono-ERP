#include "api.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
Api::Api(QObject *parent) : QObject(parent)
{

}

void Api::processCustomBill(const QString &name, const int &vendorId, const QJsonArray &items)
{
    QJsonObject params;
    params["name"]=name;
    params["items"]=items;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post("/vendors/bills/add",params)->subcribe(
                [this](NetworkResponse *res){
        emit processCustomBillResponse(res->json().toObject());
    });
}

void Api::updateProduct(const QJsonObject &product)
{
    qDebug()<<product;
    PosNetworkManager::instance()->post("/products/update",product)->subcribe(
                [this](NetworkResponse *res){
        emit updateProductReply(res->json().toObject());
    });
}


void Api::updateProduct(const int &productId, const QString &name, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes)
{
    QJsonObject params{
        {"id",productId},
        {"name",name},
        {"list_price",listPrice},
        {"cost",cost},
        {"description",description},
        {"category_id",categoryId},
        {"taxes",taxes}
    };

    PosNetworkManager::instance()->post("/products/update",params)->subcribe(
                [this](NetworkResponse *res){
        emit updateProductReply(res->json().toObject());
    });
}

void Api::requestDashboard()
{
    PosNetworkManager::instance()->get("/dashboard")->subcribe(
                [this](NetworkResponse *res){
        emit dashboardReply(res->json("data").toObject());
    });
}
