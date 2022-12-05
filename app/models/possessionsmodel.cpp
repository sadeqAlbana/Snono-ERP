#include "possessionsmodel.h"
#include "../posnetworkmanager.h"
PosSessionsModel::PosSessionsModel(QObject *parent) :  AppNetworkedJsonModel ("/posssession/opened",
                                                                              JsonModelColumnList{}
//                                                                              {"id","ID"} ,
//                                                                              {"state","State"} ,
//                                                                              {"username","User","users"} ,
//                                                                              {"created_at","Date"} ,
//                                                                              {"total","Total","orders"}}
                                                                                  ,parent)
{
    requestData();
}

void PosSessionsModel::newSession()
{
    PosNetworkManager::instance()->get("/posssession/request")->subcribe([this](NetworkResponse *res){
        emit newSessionResponse(res->json().toObject());
    });
}

void PosSessionsModel::closeSession(const int &sessionId)
{
    PosNetworkManager::instance()->post("/posssession/close",
                                        QJsonObject{{"id",sessionId}})->subcribe([this](NetworkResponse *res){
        emit closeSessionResponse(res->json().toObject());
    });
}

void PosSessionsModel::currentSession()
{
    PosNetworkManager::instance()->get("/posssession/current")->subcribe([this](NetworkResponse *res){
        emit currentSessionResponse(res->json().toObject());
    });
}