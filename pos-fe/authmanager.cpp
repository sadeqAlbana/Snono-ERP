#include "authmanager.h"
#include <QApplication>
#include <QMessageBox>
#include <QApplication>
#include <QJsonObject>
AuthManager *AuthManager::_instance;
AuthManager::AuthManager(QObject *parent) : QObject(parent)
{

}

void AuthManager::authenticate(QString username, QString password)
{
    manager.post("/auth/login",QJsonObject{{"username",username},
                                 {"password",password}})->subcribe(this,&AuthManager::onAuthReply);
}

void AuthManager::onAuthReply(NetworkResponse *res)
{
    if(res->error())
    {
        //handle Error
        qDebug()<<"error";
        qDebug()<<res->error();
    }
    else {
        if(res->json("error").isNull()){
            settings.setValue("jwt",res->json("jwt").toString());
            manager.setJWT(res->json("token").toString().toUtf8());
            emit loggedIn();
        }
        else {
            emit invalidCredentails();
        }
    }
}

AuthManager *AuthManager::instance()
{
    if(!_instance)
        _instance=new AuthManager(QApplication::instance());

    return _instance;
}
