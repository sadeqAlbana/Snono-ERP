#ifndef POSSETTINGS_H
#define POSSETTINGS_H
#include <QSettings>
class QUrl;
class PosSettings : public QSettings
{
public:
    PosSettings();

    QUrl serverUrl() const;
    void setServerUrl(const QUrl &url);
    void setServerUrl(const QString &host, const uint port, const bool useSSL);
    static QString hwID();
};

#endif // POSSETTINGS_H
