#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QSettings>
#include <posnetworkmanager.h>
#include <QJsonObject>
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

    const QJsonObject &user() const;
    void setUser(const QJsonObject &newUser);
    void resetUser();

signals:
    void loggedIn();
    void loggedOut();
    void invalidCredentails();

    void userChanged();

private:
    QSettings settings;
    QJsonObject m_user;

    static AuthManager *_instance;
    Q_PROPERTY(QJsonObject user READ user WRITE setUser RESET resetUser NOTIFY userChanged)
};

#endif // AUTHMANAGER_H
