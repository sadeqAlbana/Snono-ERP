#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkmanager.h>

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

friend class AuthManager;
};

#endif // POSNETWORKMANAGER_H
