#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QSettings>
#include "posnetworkmanager.h"
#include <QJsonObject>
class AuthManager : public QObject
{
    Q_OBJECT
private:
    explicit AuthManager(QObject *parent = nullptr);
public:
    Q_INVOKABLE void authenticate(QString username, QString password, bool remember=false);
    Q_INVOKABLE void logout();
    static AuthManager *instance();

    Q_INVOKABLE void testAuth();

    QJsonObject user() const;
    void setUser(const QJsonObject &newUser);
    void resetUser();

    Q_INVOKABLE bool hasPermission(const QString &permission) const;

    const QStringList &permissions() const;
    void setPermissions(const QStringList &newPermissions);
    void resetPermissions();

signals:
    void loggedIn();
    void loggedOut();
    void invalidCredentails();
    void testAuthResponse(bool success);
    void userChanged();

    void permissionsChanged();

private:
    QJsonObject m_user;
    QStringList m_permissions;
    static AuthManager *_instance;
    Q_PROPERTY(QJsonObject user READ user WRITE setUser RESET resetUser NOTIFY userChanged)
    Q_PROPERTY(QStringList permissions READ permissions WRITE setPermissions RESET resetPermissions NOTIFY permissionsChanged)
    void reloadPermissions();
};

#endif // AUTHMANAGER_H
