#include "employeesmodel.h"

EmployeesModel::EmployeesModel(QObject *parent) : AppNetworkedJsonModel("/employees",{
                                         {"id",tr("ID")} ,
                                         {"name",tr("Name")} ,
                                         {"address_line",tr("Address")} ,
                                         {"email",tr("Email")} ,
                                         {"phone",tr("Phone")} ,},parent)
{

}
