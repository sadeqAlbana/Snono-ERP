#include "accountsmodel.h"
#include <QJsonObject>
AccountsModel::AccountsModel(QObject *parent) : NetworkedJsonModel ("/accounts",parent)
{
    requestData();
}


ColumnList AccountsModel::columns() const
{
    return ColumnList() <<
                           Column{"name","Name"} <<
                           Column{"type","Type"} <<
                           Column{"balance","Balance","journal_entries_items"};
}

void AccountsModel::depositCash(const int &creditorId, const double &amount)
{
    QJsonObject data{{"creditor_id",creditorId},
                     {"amount",amount}};
    manager.post("/accounts/depositCash",data)->subcribe(this,&AccountsModel::onDepostCashResponse);
}

void AccountsModel::onDepostCashResponse(NetworkResponse *res)
{
    emit depositCashResponseReceived(res->json().toObject());
}
