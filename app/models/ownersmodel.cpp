#include "ownersmodel.h"

OwnersModel::OwnersModel(QObject *parent) : AppNetworkedJsonModel("/owners",{
                                         {"id",tr("ID")} ,
                                         {"name",tr("Name")} ,
                                         {"address_line",tr("Address")} ,
                                         {"email",tr("Email")} ,
                                         {"phone",tr("Phone")} ,},parent)
{

}

