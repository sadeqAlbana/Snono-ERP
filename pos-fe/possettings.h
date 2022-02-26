#ifndef POSSETTINGS_H
#define POSSETTINGS_H
#include <QSettings>
#include <QUrl>
class PosSettings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)

public:
    PosSettings();

    Q_INVOKABLE QUrl serverUrl();
    Q_INVOKABLE void setServerUrl(const QUrl &url);
    void setServerUrl(const QString &host, const uint port, const bool useSSL);
    static QString hwID();

signals:
    void serverUrlChanged(QUrl url);
};

#endif // POSSETTINGS_H
