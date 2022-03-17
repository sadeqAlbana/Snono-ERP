#ifndef APPQMLNETWORKACCESSMANAGERFACTORY_H
#define APPQMLNETWORKACCESSMANAGERFACTORY_H

#include <QQmlNetworkAccessManagerFactory>

class AppQmlNetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory
{
public:
    AppQmlNetworkAccessManagerFactory();

    QNetworkAccessManager *create(QObject *parent);
};

#endif // APPQMLNETWORKACCESSMANAGERFACTORY_H
