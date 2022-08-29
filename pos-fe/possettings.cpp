#include "possettings.h"
#include <QUrl>
#include <QDebug>
PosSettings::PosSettings()
{

}

QUrl PosSettings::serverUrl()
{

    return value("http_server_url").toUrl();
}

void PosSettings::setServerUrl(const QUrl &url)
{
    setValue("http_server_url",url);
    emit serverUrlChanged(url);
}

void PosSettings::setServerUrl(const QString &host, const uint port, const bool useSSL)
{
    QUrl url;
    url.setHost(host);
    url.setPort(port);
    url.setScheme(useSSL ? "https" : "http");

    setServerUrl(url);
}
QString PosSettings::hwID()
{
#ifdef Q_OS_ANDROID
    return QStringLiteral("galaxytabs2");
#elif defined(Q_OS_WASM)
    return QStringLiteral("wasm");
#else
    return QSysInfo::machineUniqueId();
#endif
}
