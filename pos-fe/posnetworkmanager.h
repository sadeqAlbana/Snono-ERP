#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkmanager.h>
#include <QSettings>
class PosNetworkManager : public NetworkManager
{
public:
    PosNetworkManager();
signals:
    void routeReply(QNetworkReply *reply) override;

private:
    static QByteArray _jwt;
    void setJWT(const QByteArray jwt);

    QByteArray jwt() const;
    QSettings settings;

friend class AuthManager;
};

#endif // POSNETWORKMANAGER_H
