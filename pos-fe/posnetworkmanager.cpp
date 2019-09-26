#include "posnetworkmanager.h"

PosNetworkManager::PosNetworkManager()
{
    setBaseUrl(settings.value("http_server_url").toString());
}

void PosNetworkManager::routeReply(QNetworkReply *reply)
{
    if(reply->error())
    {

    }
    NetworkManager::routeReply(reply);
}
