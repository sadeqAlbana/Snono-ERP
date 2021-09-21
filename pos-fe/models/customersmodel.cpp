#include "customersmodel.h"

CustomersModel::CustomersModel(QObject *parent) : AppNetworkedJsonModel ("/customers",ColumnList() <<
                                                                                                   Column{"id","ID"} <<
                                                                                                   Column{"name","Name"} <<
                                                                                                   Column{"first_name","First Name"} <<
                                                                                                   Column{"last_name","Last Name"} <<
                                                                                                   Column{"phone","Phone"} <<
                                                                                                   Column{"address","Address"} <<
                                                                                                   Column{"email","Email"} ,parent)
{
    requestData();
}


