#include "customersmodel.h"
#include "../posnetworkmanager.h"
CustomersModel::CustomersModel(QObject *parent) : AppNetworkedJsonModel ("/customers",{
                                                                         Column{"id",tr("ID")} ,
                                                                         Column{"name",tr("Name")} ,
                                                                         Column{"first_name",tr("First Name")} ,
                                                                         Column{"last_name",tr("Last Name")} ,
                                                                         Column{"phone",tr("Phone")} ,
                                                                         Column{"address",tr("Address")} ,
                                                                         Column{"email",tr("Email")}} ,parent)
{
}

void CustomersModel::addCustomer(const QString name, const QString firstName, const QString lastName, const QString email, const QString phone, const QString address)
{
    PosNetworkManager::instance()->post("/customers/add",QJsonObject{{"name",name},
                                                                                  {"first_name",firstName},
                                                                                  {"last_name",lastName},
                                                                                  {"email",email},
                                                                                  {"phone",phone},
                                                                                  {"address",address}})->subcribe(
                [this](NetworkResponse *res){
        emit addCustomerReply(res->json().toObject());
        refresh();
    });
}


