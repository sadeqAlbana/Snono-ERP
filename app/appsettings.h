#ifndef APPSETTINGS_H
#define APPSETTINGS_H
#include <QSettings>
#include <QUrl>
#include <QLocale>
#include <QJsonObject>
class AppSettings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)

    explicit AppSettings(QObject *parent=nullptr);
    static AppSettings *m_instance;
public:

    Q_INVOKABLE QUrl serverUrl();
    Q_INVOKABLE void setServerUrl(const QUrl &url);
    Q_INVOKABLE QLocale::Language language();
    Q_INVOKABLE void setLanguage(const QLocale::Language language);
    Q_INVOKABLE void setFont(const QString &font);
    Q_INVOKABLE QString font();
    QJsonObject user() const;
    void setUser(const QJsonObject &user);

    void setServerUrl(const QString &host, const uint port, const bool useSSL);

    static QString hwID();

    static AppSettings *instance() ;

    QByteArray jwt() const;
    void setJwt(const QByteArray &newJwt);

    static QString macAddress();
    static QByteArray deviceUuid();
signals:
    void serverUrlChanged(QUrl url);

    void jwtChanged();

private:
    Q_PROPERTY(QByteArray jwt READ jwt WRITE setJwt NOTIFY jwtChanged)
};

#endif // APPSETTINGS_H
