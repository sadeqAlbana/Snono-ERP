#include "customersmodel.h"
#include "posnetworkmanager.h"
CustomersModel::CustomersModel(QObject *parent) : AppNetworkedJsonModel ("/customers",{
                                                                         Column{"id","ID"} ,
                                                                         Column{"name","Name"} ,
                                                                         Column{"first_name","First Name"} ,
                                                                         Column{"last_name","Last Name"} ,
                                                                         Column{"phone","Phone"} ,
                                                                         Column{"address","Address"} ,
                                                                         Column{"email","Email"}} ,parent)
{
    requestData();
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
    });
}


