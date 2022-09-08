#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkmanager.h>
#include "appsettings.h"
class PosNetworkManager : public NetworkManager
{
    Q_OBJECT
private:
    PosNetworkManager(QObject *parent=nullptr);

public:
    void routeReply(QNetworkReply *reply) override;

    static PosNetworkManager *instance();

    Q_INVOKABLE void reloadBaseUrl();

signals:
    void networkReply(const int &status, const QString &message); //used for toastr service
    void networkError(const QString &title, const QString &text);

private:
    static QByteArray _jwt;
    void setJWT(const QByteArray jwt);

    QByteArray jwt() const;
    static PosNetworkManager *_instance;


friend class AuthManager;
};

#endif // POSNETWORKMANAGER_H
