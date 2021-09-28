#include "posnetworkmanager.h"
#include "messageservice.h"
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>
#include <QApplication>
QByteArray PosNetworkManager::_jwt;
PosNetworkManager* PosNetworkManager::_instance;

PosNetworkManager::PosNetworkManager(QObject *parent) : NetworkManager(parent)
{
    setBaseUrl(settings.value("http_server_url").toString());
    if(!jwt().isNull())
        setRawHeader("authorization",_jwt);
}

void PosNetworkManager::routeReply(QNetworkReply *reply)
{
    emit finishedNetworkActivity(reply->url().toString());
    NetworkResponse *response=new NetworkResponse(reply);
    qDebug()<<response->json();
    QNetworkReply::NetworkError error=response->error();
    if(error!=QNetworkReply::NoError)
    {
        if(error==QNetworkReply::InternalServerError || error==QNetworkReply::ProtocolInvalidOperationError){
            emit networkError("Internal Server Error",
                                     QString("path: '%1'\nMessage: %2").arg(response->url().path()).
                                     arg(response->json("message").toString()));
        }else{
            emit networkError("Netowork Error",response->errorString());
        }

    }
    else{
        router.route(response);
    }

    reply->deleteLater();
    delete response;

}

PosNetworkManager *PosNetworkManager::instance()
{
    if(!_instance)
        _instance=new PosNetworkManager(QApplication::instance());

    return _instance;
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
