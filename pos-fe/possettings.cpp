#include "possettings.h"
#include <QUrl>
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

}
