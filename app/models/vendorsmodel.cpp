#include "vendorsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include "authmanager.h"
VendorsModel::VendorsModel(QObject *parent) : AppNetworkedJsonModel("/vendors",{
                                                                    {"id",tr("ID")} ,
                                                                    {"name",tr("Name")} ,
                                                                    {"address",tr("Address")} ,
                                                                    {"email",tr("Email")} ,
                                                                    {"phone",tr("Phone")} ,
                                                                    {"account_id",tr("Account ID")}},parent)
{
    if(AuthManager::instance()->hasPermission("prm_view_vendors")){
        requestData();
    }
}

void VendorsModel::addVendor(const QString &name, const QString &email, const QString &address, const QString &phone)
{
    PosNetworkManager::instance()->post("/vendors/add",QJsonObject{{"name",name},
                                                                   {"email",email},
                                                                   {"address",address},
                                                                   {"phone",phone}
                                        })
            ->subcribe([this](NetworkResponse *res){

        emit vendorAddReply(res->json().toObject());
    });
}

void VendorsModel::removeVendor(const int &vendorId)
{
    PosNetworkManager::instance()->post("/vendors/remove",QJsonObject{{"id",vendorId}

                                        })
            ->subcribe([this](NetworkResponse *res){

        emit vendorRemoveReply(res->json().toObject());
    });
}
