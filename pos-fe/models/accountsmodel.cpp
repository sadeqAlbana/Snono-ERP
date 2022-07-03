#include "accountsmodel.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",{
                           Column{"code","Code"} ,
                           Column{"name","Name"} ,
                           Column{"internal_type","Internal Type",QString(),"internal_type"} ,
                           Column{"type","Type",QString(),"type"} ,
                           Column{"balance","Balance","journal_entries_items","currency"}},parent)
{
    setDirection("asc");
    requestData();

}


