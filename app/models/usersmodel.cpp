#include "usersmodel.h"

UsersModel::UsersModel(QObject *parent)  : AppNetworkedJsonModel ("/users",{
                                                                  {"id",tr("ID")} ,
                                                                  {"username",tr("User Name")} ,
                                                                  {"first_name",tr("First Name")} ,
                                                                  {"last_name",tr("Last Name")} ,
                                                                  {"phone",tr("Phone")} ,
                                                                  {"name",tr("Role"),"acl_groups"}},parent)
{
    requestData();
}


