#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QSettings>
#include <posnetworkmanager.h>
class AuthManager : public QObject
{
    Q_OBJECT
private:
    explicit AuthManager(QObject *parent = nullptr);
public:
    void authenticate(QString username, QString password);
    void onAuthReply(NetworkResponse *res);

    static AuthManager *instance();

signals:
    void loggedIn();
    void loggedOut();
    void invalidCredentails();

private:
    PosNetworkManager manager;
    QSettings settings;
    static AuthManager *_instance;
};

#endif // AUTHMANAGER_H
