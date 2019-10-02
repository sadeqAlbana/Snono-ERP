#include "posnetworkmanager.h"
QByteArray PosNetworkManager::_jwt;
PosNetworkManager::PosNetworkManager()
{
    setBaseUrl(settings.value("http_server_url").toString());
    if(!jwt().isNull())
        setRawHeader("authorization",_jwt);
}

void PosNetworkManager::routeReply(QNetworkReply *reply)
{
    /*if(reply->error())
    {

    }*/

    NetworkManager::routeReply(reply);
}

void PosNetworkManager::setJWT(const QByteArray jwt)
{
    _jwt=jwt;
}

QByteArray PosNetworkManager::jwt() const
{
    return _jwt;
}
