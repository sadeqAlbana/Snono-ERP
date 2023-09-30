#include "vendorsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include <networkresponse.h>

VendorsModel::VendorsModel(QObject *parent) : AppNetworkedJsonModel("/vendors",{
                                                                    {"id",tr("ID")} ,
                                                                    {"name",tr("Name")} ,
                                                                    {"address",tr("Address")} ,
                                                                    {"email",tr("Email")} ,
                                                                    {"phone",tr("Phone")} ,
                                                                    {"account_id",tr("Account ID")}},parent)
{

}


