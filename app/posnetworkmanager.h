#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkaccessmanager.h>
#include "appsettings.h"
class PosNetworkManager : public NetworkAccessManager
{
    Q_OBJECT
private:
    PosNetworkManager(QObject *parent=nullptr);

public:

    static PosNetworkManager *instance();

    Q_INVOKABLE void reloadBaseUrl();

signals:
    void apiReply(int status, QString message);;
private:
    static QByteArray _jwt;
    void setJWT(const QByteArray jwt);

    QByteArray jwt() const;
    static PosNetworkManager *_instance;
    void routeReply(NetworkResponse *response) override;


friend class AuthManager;
};

#endif // POSNETWORKMANAGER_H
