#include "vendorsmodel.h"
#include "posnetworkmanager.h"
#include <QJsonObject>
VendorsModel::VendorsModel(QObject *parent) : AppNetworkedJsonModel("/vendors",{
                                                                    Column{"id","ID"} ,
                                                                    Column{"name"," Name"} ,
                                                                    Column{"address","Address"} ,
                                                                    Column{"email","Email"} ,
                                                                    Column{"phone","Phone"} ,
                                                                    Column{"account_id","Account ID"}},parent)
{
    requestData();
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
