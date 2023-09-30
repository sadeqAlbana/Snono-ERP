#include "customersmodel.h"
#include "../posnetworkmanager.h"
#include <networkresponse.h>

CustomersModel::CustomersModel(QObject *parent) : AppNetworkedJsonModel ("/customers",{
                                                                         {"id",tr("ID")} ,
                                                                         {"name",tr("Name")} ,
                                                                         {"first_name",tr("First Name")} ,
                                                                         {"last_name",tr("Last Name")} ,
                                                                         {"phone",tr("Phone")} ,
                                                                         {"address",tr("Address")} ,
                                                                         {"email",tr("Email")}} ,parent)
{
}

void CustomersModel::addCustomer(const QString name, const QString firstName, const QString lastName, const QString email, const QString phone, const QString address)
{
    PosNetworkManager::instance()->post(QUrl("/customer"),QJsonObject{{"name",name},
                                                                                  {"first_name",firstName},
                                                                                  {"last_name",lastName},
                                                                                  {"email",email},
                                                                                  {"phone",phone},
                                                                                  {"address",address}})->subscribe(
                [this](NetworkResponse *res){
        emit addCustomerReply(res->json().toObject());
        refresh();
    });
}


