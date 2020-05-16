#include "posnetworkmanager.h"
#include "messageservice.h"
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>
QByteArray PosNetworkManager::_jwt;
PosNetworkManager::PosNetworkManager()
{
    setBaseUrl(settings.value("http_server_url").toString());
    if(!jwt().isNull())
        setRawHeader("authorization",_jwt);
}

void PosNetworkManager::routeReply(QNetworkReply *reply)
{
    NetworkResponse *response=new NetworkResponse(reply);
    QNetworkReply::NetworkError error=response->error();
    if(error!=QNetworkReply::NoError)
    {
        if(error==QNetworkReply::InternalServerError){
            MessageService::critical("Internal Server Error",response->json("message").toString());
        }else{
            MessageService::critical("Netowork Error",response->errorString());
        }

    }
    else{
        router.route(response);
    }

    reply->deleteLater();
    delete response;

}

void PosNetworkManager::setJWT(const QByteArray jwt)
{
    _jwt="Bearer "+ jwt;
    setRawHeader("authorization",_jwt);
}

QByteArray PosNetworkManager::jwt() const
{
    return _jwt;
}
