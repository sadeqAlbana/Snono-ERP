#include "authmanager.h"
#include <QCoreApplication>
#include <QJsonObject>
#include "appsettings.h"
#include <QJsonArray>
#include <networkresponse.h>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QFile>
#include "api.h"
#include <QDir>
AuthManager *AuthManager::_instance;
AuthManager::AuthManager(QObject *parent) : QObject(parent)
{
    connect(this,&AuthManager::userChanged,this,&AuthManager::reloadPermissions);
    connect(this,&AuthManager::loggedIn,this,&AuthManager::reloadSettings);

}

void AuthManager::authenticate(QString username, QString password, bool remember)
{
    PosNetworkManager::instance()->post(QUrl("auth/login"),QJsonObject{{"username",username},
                                                                  {"password",password},
                                                                  {"hw_id",AppSettings::hwID()},
                                                                  {"version",QString::number(AppSettings::version())}

                                        })->subscribe([this,remember](NetworkResponse *res){
        qDebug()<<"login res: " <<res->json();
        qDebug()<<res->errorString();
        if(res->json("status").toInt()==200){

            if(remember){
                AppSettings::instance()->setJwt(res->json("token").toString().toUtf8());
            }
            PosNetworkManager::instance()->setJWT(res->json("token").toString().toUtf8());
            setUser(res->json("user").toObject());
            bool test=res->json("test_env").toBool();
            AppSettings::instance()->setTestEnv(test);
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
        _instance=new AuthManager(QCoreApplication::instance());

    return _instance;
}

void AuthManager::testAuth()
{

    PosNetworkManager::instance()->setJWT(AppSettings::instance()->jwt());
    QNetworkRequest request=PosNetworkManager::instance()->createNetworkRequest(QUrl("auth/test"),QJsonObject{});
    request.setAttribute(static_cast<QNetworkRequest::Attribute>(NetworkAccessManager::RequstAttribute::OverrideErrorHandling),true);
    PosNetworkManager::instance()->post(request,QJsonObject{}

                                        )->subscribe([this](NetworkResponse *res){




        bool success=res->json("status").toInt()==200;

        if(success){
            setUser(AppSettings::instance()->user());
            bool test=res->json("test_env").toBool();
            AppSettings::instance()->setTestEnv(test);
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
    return m_permissions.contains("*") || m_permissions.contains(permission,Qt::CaseSensitive);
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
    QJsonArray items=m_user["acl_group"].toObject()["acl_items"].toArray();
    if(items.isEmpty()){
        items=m_user["acl_group"].toObject()["items"].toArray();
    }
    QStringList permissions;
    for(const QJsonValue &item : items){
        permissions << item["permission"].toString();
    }
    setPermissions(permissions);
}

void AuthManager::reloadSettings()
{

    Api::instance()->config()->subscribe([](NetworkResponse *res){

        QJsonObject data=res->json("data").toObject();
        qDebug()<<"data: " <<data;
        QByteArray imageData=QByteArray::fromBase64(res->json("data")["receipt_logo"].toString().toUtf8());
        if(imageData.size()){
            QDir().mkpath(AppSettings::storagePath()+"/assets");
            QImage image=QImage::fromData(imageData);
            image.save(AppSettings::storagePath()+"/assets/"+"receipt_logo.png");
        }

        // AppSettings::instance()->setReceiptCompanyName(data["receipt_company_name"].toString());
        // AppSettings::instance()->setReceiptPhoneNumber(data["receipt_phone"].toString());
        // AppSettings::instance()->setReceiptBottomNote(data["receipt_bottom_note"].toString());
        // AppSettings::instance()->setPosReceiptBottomNote(data["receipt_pos_bottom_note"].toString());
        // AppSettings::instance()->setAddressQr(data["receipt_address_qr_data"].toString());
        // AppSettings::instance()->setReceiptAddressLine(data["receipt_address_line"].toString());

    });


}
