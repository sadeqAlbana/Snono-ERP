#ifndef APPSETTINGS_H
#define APPSETTINGS_H
#include <QSettings>
#include <QUrl>
#include <QLocale>
#include <QJsonObject>
#include <QPageSize>
class AppSettings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(QString receiptPrinter READ receiptPrinter WRITE setReceiptPrinter NOTIFY receiptPrinterChanged )
    Q_PROPERTY(QString reportsPrinter READ reportsPrinter WRITE setReportsPrinter NOTIFY reportsPrinterChanged )

    Q_PROPERTY(QString receiptPaperSize READ receiptPaperSize WRITE setReceiptPaperSize NOTIFY receiptPaperSizeChanged )
    Q_PROPERTY(QString reportsPaperSize READ reportsPaperSize WRITE setReportsPaperSize NOTIFY reportsPaperSizeChanged )
    explicit AppSettings(QObject *parent=nullptr);
    static AppSettings *m_instance;
public:
    Q_INVOKABLE  QString about();

    Q_INVOKABLE QUrl serverUrl();
    Q_INVOKABLE void setServerUrl(const QUrl &url);
    Q_INVOKABLE QStringList servers();
    Q_INVOKABLE void setServers(const QStringList &newServers);

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
    QString receiptPrinter() const;
    void setReceiptPrinter(const QString &newReceiptPrinter);

    QString reportsPrinter() const;
    void setReportsPrinter(const QString &newReportsPrinter);

    QString receiptPaperSize() const;
    void setReceiptPaperSize(const QString &newReceiptPaperSize);

    QString reportsPaperSize() const;
    void setReportsPaperSize(const QString &newReportsPaperSize);


    static QPageSize pageSizeFromString(const QString &pageSize);

    bool receiptLinePrinter() const;
    void setReceiptLinePrinter(bool newReceiptLinePrinter);

    int receiptCopiesWithExternalDelivery() const;
    void setReceiptCopiesWithExternalDelivery(int newReceiptCopiesWithExternalDelivery);
    Q_INVOKABLE QVariant get(const QString &key,QVariant defaultValue=QVariant());
    Q_INVOKABLE void set(const QString &key, const QVariant &value);

    float labelPrinterLabelWidth() const;
    void setLabelPrinterLabelWidth(float newLabelPrinterLabelWidth);

    float labelPrinterLabelHeight() const;
    void setLabelPrinterLabelHeight(float newLabelPrinterLabelHeight);

    int labelPrinterLabelSizeUnit() const;
    void setLabelPrinterLabelSizeUnit(int newLabelPrinterLabelSizeUnit);

signals:
    void serverUrlChanged(QUrl url);

    void jwtChanged();

    void receiptCopiesChanged();

    void externalReceiptCopiesChanged();

    void externalDeliveryChanged();

    void receiptPrinterChanged();

    void reportsPrinterChanged();

    void receiptPaperSizeChanged();

    void reportsPaperSizeChanged();

    void receiptLinePrinterChanged();

    void receiptCopiesWithExternalDeliveryChanged();

    void labelPrinterLabelWidthChanged();

    void labelPrinterLabelHeightChanged();

    void labelPrinterLabelSizeUnitChanged();

private:


    Q_PROPERTY(QByteArray jwt READ jwt WRITE setJwt NOTIFY jwtChanged)
    Q_PROPERTY(int receiptCopies READ receiptCopies WRITE setReceiptCopies NOTIFY receiptCopiesChanged)
    Q_PROPERTY(int externalReceiptCopies READ externalReceiptCopies WRITE setExternalReceiptCopies NOTIFY externalReceiptCopiesChanged)

    Q_PROPERTY(bool externalDelivery READ externalDelivery WRITE setExternalDelivery NOTIFY externalDeliveryChanged)

    Q_PROPERTY(bool receiptLinePrinter READ receiptLinePrinter WRITE setReceiptLinePrinter NOTIFY receiptLinePrinterChanged FINAL)
    Q_PROPERTY(int receiptCopiesWithExternalDelivery READ receiptCopiesWithExternalDelivery WRITE setReceiptCopiesWithExternalDelivery NOTIFY receiptCopiesWithExternalDeliveryChanged FINAL)

    Q_PROPERTY(float labelPrinterLabelWidth READ labelPrinterLabelWidth WRITE setLabelPrinterLabelWidth NOTIFY labelPrinterLabelWidthChanged FINAL)
    Q_PROPERTY(float labelPrinterLabelHeight READ labelPrinterLabelHeight WRITE setLabelPrinterLabelHeight NOTIFY labelPrinterLabelHeightChanged FINAL)
    Q_PROPERTY(int labelPrinterLabelSizeUnit READ labelPrinterLabelSizeUnit WRITE setLabelPrinterLabelSizeUnit NOTIFY labelPrinterLabelSizeUnitChanged FINAL)
};

#endif // APPSETTINGS_H
