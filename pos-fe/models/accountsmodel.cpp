#include "accountsmodel.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
AccountsModel::AccountsModel(QObject *parent) :
    AppNetworkedJsonModel ("/accounts",ColumnList() <<
                                                       Column{"name","Name"} <<
                                                       Column{"type","Type"} <<
                                                       Column{"balance","Balance","journal_entries_items"},parent)
{
    //requestData();
}


void AccountsModel::depositCash(const int &creditorId, const double &amount)
{
    QJsonObject data{{"creditor_id",creditorId},
                     {"amount",amount}};
    PosNetworkManager::instance()->post("/accounts/depositCash",data)->subcribe(this,&AccountsModel::onDepostCashResponse);
}

void AccountsModel::onDepostCashResponse(NetworkResponse *res)
{
    emit depositCashResponseReceived(res->json().toObject());
}
