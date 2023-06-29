#include "possessionsmodel.h"
#include "../posnetworkmanager.h"
#include <networkresponse.h>

PosSessionsModel::PosSessionsModel(QObject *parent) :  AppNetworkedJsonModel ("/posssession/opened",
                                                                              JsonModelColumnList{}
//                                                                              {"id","ID"} ,
//                                                                              {"state","State"} ,
//                                                                              {"username","User","users"} ,
//                                                                              {"created_at","Date"} ,
//                                                                              {"total","Total","orders"}}
                                                                                  ,parent)
{
   
}

void PosSessionsModel::newSession()
{
    PosNetworkManager::instance()->get(QUrl("/posssession/request"))->subscribe([this](NetworkResponse *res){
        emit newSessionResponse(res->json().toObject());
    });
}

void PosSessionsModel::closeSession(const int &sessionId)
{
    PosNetworkManager::instance()->post(QUrl("/posssession/close"),
                                        QJsonObject{{"id",sessionId}})->subscribe([this](NetworkResponse *res){
        emit closeSessionResponse(res->json().toObject());
    });
}

void PosSessionsModel::currentSession()
{
    PosNetworkManager::instance()->get(QUrl("/posssession/current"))->subscribe([this](NetworkResponse *res){
        emit currentSessionResponse(res->json().toObject());
    });
}
