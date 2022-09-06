#ifndef APPSETTINGS_H
#define APPSETTINGS_H
#include <QSettings>
#include <QUrl>
#include <QLocale>
class AppSettings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)

public:
    explicit AppSettings(QObject *parent=nullptr);

    Q_INVOKABLE QUrl serverUrl();
    Q_INVOKABLE void setServerUrl(const QUrl &url);
    Q_INVOKABLE QLocale::Language language();
    Q_INVOKABLE void setLanguage(const QLocale::Language language);
    Q_INVOKABLE void setFont(const QString &font);
    Q_INVOKABLE QString font();

    void setServerUrl(const QString &host, const uint port, const bool useSSL);

    static QString hwID();

signals:
    void serverUrlChanged(QUrl url);
};

#endif // APPSETTINGS_H
