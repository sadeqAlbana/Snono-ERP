#include "authmanager.h"
#include <QApplication>
#include <QMessageBox>
#include <QApplication>
#include <QJsonObject>
#include "appsettings.h"
#include <QJsonArray>
AuthManager *AuthManager::_instance;
AuthManager::AuthManager(QObject *parent) : QObject(parent)
{

}

void AuthManager::authenticate(QString username, QString password)
{
    PosNetworkManager::instance()->post("/auth/login",QJsonObject{{"username",username},
                                 {"password",password},
                                 {"hw_id",AppSettings::hwID()}

                                        })->subcribe(this,&AuthManager::onAuthReply);
}

void AuthManager::onAuthReply(NetworkResponse *res)
{
        if(res->json("status").toInt()==200){
            settings.setValue("jwt",res->json("token").toString());
            PosNetworkManager::instance()->setJWT(res->json("token").toString().toUtf8());
            setUser(res->json("user").toObject());

            QJsonArray items=m_user["acl_group"].toObject()["items"].toArray();
            QStringList permissions;
            for(const QJsonValue &item : items){
                permissions << item["permission"].toString();
            }
            setPermissions(permissions);
            emit loggedIn();

        }
        else {
            emit invalidCredentails();
        }
}

void AuthManager::logout()
{
    settings.setValue("jwt",QVariant());
    PosNetworkManager::instance()->setJWT(QByteArray());
    emit loggedOut();
}

AuthManager *AuthManager::instance()
{
    if(!_instance)
        _instance=new AuthManager(QApplication::instance());

    return _instance;
}

QJsonObject AuthManager::user() const
{
    return m_user;
}

void AuthManager::setUser(const QJsonObject &newUser)
{
    if (m_user == newUser)
        return;
    m_user = newUser;
    emit userChanged();
}

void AuthManager::resetUser()
{
    setUser({}); // TODO: Adapt to use your actual default value
}

bool AuthManager::hasPermission(const QString &permission) const
{
    return m_permissions.contains("*") || m_permissions.contains(permission);
}

const QStringList &AuthManager::permissions() const
{
    return m_permissions;
}

void AuthManager::setPermissions(const QStringList &newPermissions)
{
    if (m_permissions == newPermissions)
        return;
    m_permissions = newPermissions;
    emit permissionsChanged();
}

void AuthManager::resetPermissions()
{
    setPermissions({}); // TODO: Adapt to use your actual default value
}
