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
    Q_INVOKABLE void authenticate(QString username, QString password);
    void onAuthReply(NetworkResponse *res);
    Q_INVOKABLE void logout();
    static AuthManager *instance();

signals:
    void loggedIn();
    void loggedOut();
    void invalidCredentails();

private:
    QSettings settings;
    static AuthManager *_instance;
};

#endif // AUTHMANAGER_H
