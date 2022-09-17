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
    connect(this,&AuthManager::userChanged,this,&AuthManager::reloadPermissions);
}

void AuthManager::authenticate(QString username, QString password, bool remember)
{
    PosNetworkManager::instance()->post("/auth/login",QJsonObject{{"username",username},
                                                                  {"password",password},
                                                                  {"hw_id",AppSettings::hwID()}

                                        })->subcribe([this,remember](NetworkResponse *res){
        if(res->json("status").toInt()==200){

            if(remember){
                AppSettings::instance()->setJwt(res->json("token").toString().toUtf8());
            }
            PosNetworkManager::instance()->setJWT(res->json("token").toString().toUtf8());
            setUser(res->json("user").toObject());
            emit loggedIn();

        }
        else {
            emit invalidCredentails();
        }
    });
}



void AuthManager::logout()
{
    AppSettings::instance()->setValue("jwt",QVariant());
    PosNetworkManager::instance()->setJWT(QByteArray());
    emit loggedOut();
}

AuthManager *AuthManager::instance()
{
    if(!_instance)
        _instance=new AuthManager(QApplication::instance());

    return _instance;
}

void AuthManager::testAuth()
{

    PosNetworkManager::instance()->setJWT(AppSettings::instance()->jwt());
    PosNetworkManager::instance()->post("/auth/test",QJsonObject{}

                                        )->subcribe([this](NetworkResponse *res){

        bool success=res->json("status").toInt()==200;

        if(success){
            setUser(AppSettings::instance()->user());
        }

        emit testAuthResponse(success);


    });
}

QJsonObject AuthManager::user() const
{
    return m_user;
}

void AuthManager::setUser(const QJsonObject &newUser)
{
    if (m_user == newUser)
        return;

    AppSettings::instance()->setUser(newUser);
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

void AuthManager::reloadPermissions()
{
    QJsonArray items=m_user["acl_group"].toObject()["items"].toArray();
    QStringList permissions;
    for(const QJsonValue &item : items){
        permissions << item["permission"].toString();
    }
    setPermissions(permissions);
}
