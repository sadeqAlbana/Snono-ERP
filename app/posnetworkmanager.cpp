#include "posnetworkmanager.h"
#include "networkresponse.h"
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>
#include <QApplication>
#include <QNetworkDiskCache>
#include <QStandardPaths>
QByteArray PosNetworkManager::_jwt;
PosNetworkManager* PosNetworkManager::_instance;

PosNetworkManager::PosNetworkManager(QObject *parent) : NetworkAccessManager(parent)
{
    reloadBaseUrl();
//    setRawHeader("Connection","close");
    setTransferTimeout(QNetworkRequest::DefaultTransferTimeoutConstant);
    setIgnoredSslErrors(QList<QSslError>());
    //setTransferTimeout(10*1000);

    if(!jwt().isNull())
        setRawHeader("Authorization",_jwt);
//    ignoreSslErrors(true);

    QNetworkDiskCache* cache = new QNetworkDiskCache(this);
    QString cachePath = QStandardPaths::displayName(QStandardPaths::CacheLocation);
    cache->setCacheDirectory(cachePath);
    setCache(cache);
    setRequestAttribute(static_cast<QNetworkRequest::Attribute>(RequstAttribute::NotifyActivity),true);

    connect(this,&NetworkAccessManager::networkError,this,[this](NetworkResponse *response){
        emit internalNetworkError("Netowork Error",
                          response->networkReply()->errorString());


    });
}

void PosNetworkManager::routeReply(NetworkResponse *response)
{
    NetworkAccessManager::routeReply(response);
    if(response->json().toObject().contains("status")){

        int status = response->json("status").toInt();
        QString message=response->json("message").toString();
        if(!message.isEmpty()){
        if(status==200){
            emit networkReply(response->json("status").toInt(),message);
        }else{
            emit apiError("Error",message);
        }
        }
    }
}

PosNetworkManager *PosNetworkManager::instance()
{
    if(!_instance)
        _instance=new PosNetworkManager(QApplication::instance());

    return _instance;
}

void PosNetworkManager::reloadBaseUrl()
{
    setBaseUrl(AppSettings::instance()->serverUrl().toString());
}


void PosNetworkManager::setJWT(const QByteArray jwt)
{
    _jwt="Bearer "+ jwt;
    setRawHeader("Authorization",_jwt);
}

QByteArray PosNetworkManager::jwt() const
{
    return _jwt;
}
