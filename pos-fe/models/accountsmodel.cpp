#include "accountsmodel.h"
#include <QJsonObject>
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",{
                           Column{"id","ID"} ,
                           Column{"code","Code"} ,
                           Column{"name","Name"} ,
                           Column{"internal_type","Internal Type",QString(),"internal_type"} ,
                           Column{"type","Type",QString(),"type"} ,
                           Column{"balance","Balance","journal_entries_items","currency"}},parent)
{
    setDirection("asc");
    requestData();

}

QVariant AccountsModel::data(const QModelIndex &index, int role) const
{

    if(role==Qt::DisplayRole && index.column()==indexOf("code")){
        return QString::number(AppNetworkedJsonModel::data(index,role).toInt());
    }
    return AppNetworkedJsonModel::data(index,role);

}


