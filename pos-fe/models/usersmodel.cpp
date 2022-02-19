#include "usersmodel.h"

UsersModel::UsersModel(QObject *parent)  : AppNetworkedJsonModel ("/users",{
                                                                  Column{"id","ID"} ,
                                                                  Column{"username","User Name"} ,
                                                                  Column{"first_name","First Name"} ,
                                                                  Column{"last_name","Last Name"} ,
                                                                  Column{"phone","Phone"} ,
                                                                  Column{"name","Role","acl_groups"}},parent)
{
    requestData();
}


