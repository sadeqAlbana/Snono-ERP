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

