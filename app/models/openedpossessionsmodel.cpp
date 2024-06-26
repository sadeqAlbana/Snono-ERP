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

void OpenedPosSessionsModel::newSession()
{
    PosNetworkManager::instance()->get(QUrl("/posssession/request"))->subscribe([this](NetworkResponse *res){
        emit newSessionResponse(res->json().toObject());
    });
}

void OpenedPosSessionsModel::closeSession(const int &sessionId)
{
    PosNetworkManager::instance()->post(QUrl("/posssession/close"),
                                        QJsonObject{{"id",sessionId}})->subscribe([this](NetworkResponse *res){
        emit closeSessionResponse(res->json().toObject());
    });
}

void OpenedPosSessionsModel::currentSession()
{
    PosNetworkManager::instance()->get(QUrl("/posssession/current"))->subscribe([this](NetworkResponse *res){
        emit currentSessionResponse(res->json().toObject());
    });
}
