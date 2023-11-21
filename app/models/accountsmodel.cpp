#include "accountsmodel.h"
#include <QJsonObject>
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",{
                           {"id",tr("ID")} ,
                           {"code",tr("Code")} ,
                           {"name",tr("Name")} ,
                           {"internal_type",tr("Internal Type"),QString(),false,"internal_type"} ,
                           {"type",tr("Type"),QString(),false,"type"} ,
                           {"balance",tr("Balance"),QString(),false,"currency"}},parent)
{
    setDirection("asc");


}

QVariant AccountsModel::data(const QModelIndex &index, int role) const
{

    if(role==Qt::DisplayRole && index.column()==indexOf("code")){
        return QString::number(AppNetworkedJsonModel::data(index,role).toInt());
    }
    return AppNetworkedJsonModel::data(index,role);

}


