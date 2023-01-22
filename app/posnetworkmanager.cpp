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
}

void PosNetworkManager::routeReply(NetworkResponse *response)
{

    NetworkAccessManager::routeReply(response);
//    //emit finishedNetworkActivity(reply->url().toString());
//    //qDebug()<<response->json();
//    QNetworkReply::NetworkError error=response->error();
//    if(error!=QNetworkReply::NoError)
//    {
//        qDebug()<<response->url() << " " <<response->error();

//        if(error==QNetworkReply::InternalServerError || error==QNetworkReply::ProtocolInvalidOperationError){
//            emit networkError("Internal Server Error",
//                                     QString("path: '%1'\nMessage: %2").arg(response->url().path(),
//                                     response->json("message").toString()));
//        }else{
//            emit networkError("Netowork Error",response->errorString());
//        }

//        if(response->url().toString().contains("/auth/test")){
//            m_router.route(response);
//        }

//    }
//    else{
//        m_router.route(response);

//        if(response->json().toObject().contains("message")){
//            emit networkReply(response->json("status").toInt(),response->json("message").toString());
//        }
//    }

//    reply->deleteLater();
//    delete response;

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
