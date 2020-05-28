#include "possettings.h"
#include <QUrl>
#include <QDebug>
PosSettings::PosSettings()
{

}

QUrl PosSettings::serverUrl() const
{
    return value("http_server_url").toUrl();
}

void PosSettings::setServerUrl(const QUrl &url)
{
    setValue("http_server_url",url);
}

void PosSettings::setServerUrl(const QString &host, const uint port, const bool useSSL)
{
    QUrl url;
    url.setHost(host);
    url.setPort(port);
    url.setScheme(useSSL ? "https" : "http");

    setServerUrl(url);
}
