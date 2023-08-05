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
    static QString storagePath();

    static QString hwID();

    static AppSettings *instance() ;

    QByteArray jwt() const;
    void setJwt(const QByteArray &newJwt);

    static QString macAddress();
    static QByteArray deviceUuid();
    int receiptCopies() const;
    void setReceiptCopies(int newReceiptCopies);

    int externalReceiptCopies() const;
    void setExternalReceiptCopies(int newExternalReceiptCopies);

    bool externalDelivery() const;
    void setExternalDelivery(bool newExternalDelivery);


    void setReceiptCompanyName(const QString &name);
    void setReceiptPhoneNumber(const QString &phoneNumber);
    void setReceiptBottomNote(const QString &bottomNote);

    QString receiptCompanyName() const;
    QString receiptPhoneNumber() const;
    QString receiptBottomNote() const;




    static QString platform();
    Q_INVOKABLE static int version();
signals:
    void serverUrlChanged(QUrl url);

    void jwtChanged();

    void receiptCopiesChanged();

    void externalReceiptCopiesChanged();

    void externalDeliveryChanged();

private:
    Q_PROPERTY(QByteArray jwt READ jwt WRITE setJwt NOTIFY jwtChanged)
    Q_PROPERTY(int receiptCopies READ receiptCopies WRITE setReceiptCopies NOTIFY receiptCopiesChanged)
    Q_PROPERTY(int externalReceiptCopies READ externalReceiptCopies WRITE setExternalReceiptCopies NOTIFY externalReceiptCopiesChanged)

    Q_PROPERTY(bool externalDelivery READ externalDelivery WRITE setExternalDelivery NOTIFY externalDeliveryChanged)
};

#endif // APPSETTINGS_H
