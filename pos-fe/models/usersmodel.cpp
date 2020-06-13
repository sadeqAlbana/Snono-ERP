#include "usersmodel.h"

UsersModel::UsersModel(QObject *parent)  : NetworkedJsonModel ("/users",parent)
{
    requestData();
}


ColumnList UsersModel::columns() const
{
    return ColumnList() <<
                           Column{"id","ID"} <<
                           Column{"username","User Name"} <<
                           Column{"first_name","First Name"} <<
                           Column{"last_name","Last Name"} <<
                           Column{"phone","Phone"} <<
                           Column{"name","Type","acl_groups"};
}
