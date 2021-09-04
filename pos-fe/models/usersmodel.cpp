#include "usersmodel.h"

UsersModel::UsersModel(QObject *parent)  : AppNetworkedJsonModel ("/users",ColumnList() <<
                                                                                           Column{"id","ID"} <<
                                                                                           Column{"username","User Name"} <<
                                                                                           Column{"first_name","First Name"} <<
                                                                                           Column{"last_name","Last Name"} <<
                                                                                           Column{"phone","Phone"} <<
                                                                                           Column{"name","Type","acl_groups"},parent)
{
    //requestData();
}


