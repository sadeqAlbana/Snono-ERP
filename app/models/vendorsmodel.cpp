#include "vendorsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include <networkresponse.h>

VendorsModel::VendorsModel(QObject *parent) : AppNetworkedJsonModel("/vendors",{
                                                                    {"id",tr("ID")} ,
                                                                    {"name",tr("Name")} ,
                                                                    {"address_line",tr("Address")} ,
                                                                    {"email",tr("Email")} ,
                                                                    {"phone",tr("Phone")}},parent)
{

}


