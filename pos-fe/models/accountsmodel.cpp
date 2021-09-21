#include "accountsmodel.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",ColumnList() <<
                                                       Column{"code","Code"} <<
                                                       Column{"name","Name"} <<
                                                       Column{"internal_type","Internal Type",QString(),"internal_type"} <<
                                                       Column{"type","Type",QString(),"type"} <<
                                                       Column{"balance","Balance","journal_entries_items","currency"},parent)
{
    requestData();
}


void AccountsModel::depositCash(const double &amount)
{
    QJsonObject data{
                     {"amount",amount}};
    PosNetworkManager::instance()->post("/accounts/depositCash",data)->subcribe(this,&AccountsModel::onDepostCashResponse);
}

void AccountsModel::onDepostCashResponse(NetworkResponse *res)
{
    emit depositCashResponseReceived(res->json().toObject());
}
