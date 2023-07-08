#include "appsettings.h"
#include <QUrl>
#include <QDebug>
#include <QCoreApplication>
#include <QJsonDocument>
#include <QNetworkInterface>
#include <QUuid>
AppSettings* AppSettings::m_instance;

AppSettings::AppSettings(QObject *parent) : QSettings(parent)
{

}

AppSettings *AppSettings::instance()
{
    if(!m_instance)
        m_instance= new AppSettings(qApp);
    return m_instance;
}

QByteArray AppSettings::jwt() const
{
    return value("jwt").toByteArray();
}

void AppSettings::setJwt(const QByteArray &newJwt)
{
    if (jwt() == newJwt)
        return;
    setValue("jwt",newJwt);
    emit jwtChanged();
}

QString AppSettings::macAddress()
{
#ifndef Q_OS_WASM
        for(QNetworkInterface netInterface: QNetworkInterface::allInterfaces())
        {
            // Return only the first non-loopback MAC Address
            if (!(netInterface.flags() & QNetworkInterface::IsLoopBack))
                return netInterface.hardwareAddress();
        }
#endif
        return QString();

}

QByteArray AppSettings::deviceUuid()
{
    QByteArray value=instance()->value("uuid").toByteArray();
    if(value.isEmpty()){
        QUuid uuid=QUuid::createUuid();
        instance()->setValue("uuid",uuid.toByteArray(QUuid::WithoutBraces));
        value=instance()->value("uuid").toByteArray();
    }
    return value;
}

int AppSettings::receiptCopies() const
{
    return value("receipt_copies",1).toInt();
}

void AppSettings::setReceiptCopies(int newReceiptCopies)
{
    if (receiptCopies() == newReceiptCopies)
        return;
    setValue("receipt_copies", newReceiptCopies);
    emit receiptCopiesChanged();
}

int AppSettings::externalReceiptCopies() const
{
    return value("external_receipt_copies",3).toInt();
}

void AppSettings::setExternalReceiptCopies(int newExternalReceiptCopies)
{
    if (externalReceiptCopies() == newExternalReceiptCopies)
        return;
    setValue("external_receipt_copies", newExternalReceiptCopies);
    emit externalReceiptCopiesChanged();
}

bool AppSettings::externalDelivery() const
{
    return value("external_delivery",false).toBool();
}

void AppSettings::setExternalDelivery(bool newExternalDelivery)
{
    if (externalDelivery() == newExternalDelivery)
        return;
    setValue("external_delivery", newExternalDelivery);
    emit externalDeliveryChanged();
}

QString AppSettings::platform()
{
    return QSysInfo::kernelType();
}

int AppSettings::version()
{
    return APP_VERSION;
}



QUrl AppSettings::serverUrl()
{
    return value("http_server_url").toUrl();
}

void AppSettings::setServerUrl(const QUrl &url)
{
    setValue("http_server_url",url);
    emit serverUrlChanged(url);
}

QLocale::Language AppSettings::language()
{
    return static_cast<QLocale::Language>(value("app_language",QLocale::English).toUInt());
}

void AppSettings::setLanguage(const QLocale::Language language)
{
    setValue("app_language",language);

}

void AppSettings::setFont(const QString &font)
{
    setValue("app_font",font);
}

QString AppSettings::font()
{
    return value("app_font","Arial").toString();
}

QJsonObject AppSettings::user() const
{
    QJsonDocument doc=QJsonDocument::fromJson(this->value("user").toByteArray());

    return doc.object();
}

void AppSettings::setUser(const QJsonObject &user)
{
    QJsonDocument doc(user);
    setValue("user",doc.toJson(QJsonDocument::Compact));
}

void AppSettings::setServerUrl(const QString &host, const uint port, const bool useSSL)
{
    QUrl url;
    url.setHost(host);
    url.setPort(port);
    url.setScheme(useSSL ? "https" : "http");

    setServerUrl(url);
}
QString AppSettings::hwID()
{

#ifdef Q_OS_ANDROID
    return deviceUuid();
#elif defined(Q_OS_WASM)
    return QStringLiteral("wasm");
#else
    return QSysInfo::machineUniqueId();
#endif
}
