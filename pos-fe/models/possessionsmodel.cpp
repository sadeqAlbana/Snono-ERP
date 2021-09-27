#include "possessionsmodel.h"
#include "posnetworkmanager.h"
PosSessionsModel::PosSessionsModel(QObject *parent) :  AppNetworkedJsonModel ("/posssession/opened",
                                                                              ColumnList()
//                                                                              Column{"id","ID"} <<
//                                                                              Column{"state","State"} <<
//                                                                              Column{"username","User","users"} <<
//                                                                              Column{"created_at","Date"} <<
//                                                                              Column{"total","Total","orders"}
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
