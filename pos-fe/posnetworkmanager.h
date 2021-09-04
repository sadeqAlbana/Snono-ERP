#ifndef POSNETWORKMANAGER_H
#define POSNETWORKMANAGER_H
#include <networkmanager.h>
#include <QSettings>
class PosNetworkManager : public NetworkManager
{
    Q_OBJECT
private:
    PosNetworkManager(QObject *parent=nullptr);

public:
    void routeReply(QNetworkReply *reply) override;

    static PosNetworkManager *instance();


signals:
    void networkError(const QString &title, const QString &text);

private:
    static QByteArray _jwt;
    void setJWT(const QByteArray jwt);

    QByteArray jwt() const;
    QSettings settings;
    static PosNetworkManager *_instance;


friend class AuthManager;
};

#endif // POSNETWORKMANAGER_H
