#include "appqmlnetworkaccessmanagerfactory.h"
#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QStandardPaths>
AppQmlNetworkAccessManagerFactory::AppQmlNetworkAccessManagerFactory()
    : QQmlNetworkAccessManagerFactory{}
{

}

QNetworkAccessManager *AppQmlNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager *mgr= new QNetworkAccessManager(parent);
    QNetworkDiskCache* cache = new QNetworkDiskCache(mgr);
    QString cachePath = QStandardPaths::displayName(QStandardPaths::CacheLocation);
    cache->setCacheDirectory(cachePath);
    mgr->setCache(cache);
    return mgr;
}
