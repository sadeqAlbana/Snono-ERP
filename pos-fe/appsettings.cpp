#include "appsettings.h"
#include <QUrl>
#include <QDebug>
#include <QCoreApplication>
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
    return QStringLiteral("galaxytabs2");
#elif defined(Q_OS_WASM)
    return QStringLiteral("wasm");
#else
    return QSysInfo::machineUniqueId();
#endif
}
