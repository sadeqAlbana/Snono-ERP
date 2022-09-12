#include "accountsmodel.h"
#include <QJsonObject>
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",{
                           Column{"id",tr("ID")} ,
                           Column{"code",tr("Code")} ,
                           Column{"name",tr("Name")} ,
                           Column{"internal_type",tr("Internal Type"),QString(),"internal_type"} ,
                           Column{"type",tr("Type"),QString(),"type"} ,
                           Column{"balance",tr("Balance"),"journal_entries_items","currency"}},parent)
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


