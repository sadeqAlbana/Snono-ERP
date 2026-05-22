#include "openedpossessionsmodel.h"
#include "../posnetworkmanager.h"
#include <networkresponse.h>

OpenedPosSessionsModel::OpenedPosSessionsModel(QObject *parent) :  AppNetworkedJsonModel ("/posssession/opened",
                                                                              JsonModelColumnList{}
//                                                                              {"id","ID"} ,
//                                                                              {"state","State"} ,
//                                                                              {"username","User","users"} ,
//                                                                              {"created_at","Date"} ,
//                                                                              {"total","Total","orders"}}
                                                                                  ,parent)
{
   
}

void OpenedPosSessionsModel::newSession(double openingBalance)
{
    PosNetworkManager::instance()->post(QUrl("/posssession/request"),
                                        QJsonObject{{"opening_balance", openingBalance}})
        ->subscribe([this](NetworkResponse *res){
            emit newSessionResponse(res->json().toObject());
        });
}

void OpenedPosSessionsModel::closeSession(const int &sessionId, double closingBalance, double depositAmount)
{
    PosNetworkManager::instance()->post(QUrl("/posssession/close"),
                                        QJsonObject{{"id",              sessionId},
                                                    {"closing_balance", closingBalance},
                                                    {"deposit_amount",  depositAmount}})
        ->subscribe([this](NetworkResponse *res){
            emit closeSessionResponse(res->json().toObject());
        });
}

void OpenedPosSessionsModel::currentSession()
{
    PosNetworkManager::instance()->get(QUrl("/posssession/current"))->subscribe([this](NetworkResponse *res){
        emit currentSessionResponse(res->json().toObject());
    });
}
