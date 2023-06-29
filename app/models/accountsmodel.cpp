#include "accountsmodel.h"
#include <QJsonObject>
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",{
                           {"id",tr("ID")} ,
                           {"code",tr("Code")} ,
                           {"name",tr("Name")} ,
                           {"internal_type",tr("Internal Type"),QString(),"internal_type"} ,
                           {"type",tr("Type"),QString(),"type"} ,
                           {"balance",tr("Balance"),QString(),"currency"}},parent)
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


