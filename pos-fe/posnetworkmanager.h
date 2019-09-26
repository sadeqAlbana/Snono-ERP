#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkmanager.h>

class PosNetworkManager : public NetworkManager
{
public:
    PosNetworkManager();
signals:
    void routeReply(QNetworkReply *reply) override;
};

#endif // POSNETWORKMANAGER_H
