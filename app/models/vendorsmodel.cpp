#include "vendorsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include <networkresponse.h>

VendorsModel::VendorsModel(QObject *parent) : AppNetworkedJsonModel("/vendors",{
                                                                    {"id",tr("ID")} ,
                                                                    {"name",tr("Name")} ,
                                                                    {"address",tr("Address")} ,
                                                                    {"email",tr("Email")} ,
                                                                    {"phone",tr("Phone")} ,
                                                                    {"account_id",tr("Account ID")}},parent)
{

}

void VendorsModel::addVendor(const QString &name, const QString &email, const QString &address, const QString &phone)
{
    PosNetworkManager::instance()->post(QUrl("/vendors/add"),QJsonObject{{"name",name},
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
    PosNetworkManager::instance()->post(QUrl("/vendors/remove"),QJsonObject{{"id",vendorId}

                                        })
            ->subcribe([this](NetworkResponse *res){

        emit vendorRemoveReply(res->json().toObject());
    });
}
