#ifndef APPSETTINGS_H
#define APPSETTINGS_H
#include <QSettings>
#include <QUrl>
#include <QLocale>
#include <QJsonObject>
#include <QPageSize>
#include <QJsonArray>
class AppSettings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(QString receiptPrinter READ receiptPrinter WRITE setReceiptPrinter NOTIFY receiptPrinterChanged )
    Q_PROPERTY(QString labelPrinter READ labelPrinter WRITE setLabelPrinter NOTIFY labelPrinterChanged )

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

    static QPageSize::Unit pageSizeUnitFromString(const QString &unit);

    Q_INVOKABLE static QJsonArray qPageSizeUnits();
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

    QString labelPrinter() const;
    void setLabelPrinter(const QString &newLabelPrinter);

    bool testEnv() const;
    void setTestEnv(bool newTestEnv);

    QString posReceiptBottomNote() const;
    void setPosReceiptBottomNote(const QString &newPosReceiptBottomNote);


    QString linePrinter() const;
    void setLinePrinter(const QString &newLinePrinter);


    QString linePrinterPaperSize() const;
    void setLinePrinterPaperSize(const QString &newLinePrinterPaperSize);

signals:
    void serverUrlChanged(QUrl url);

    void jwtChanged();

    void receiptCopiesChanged();

    void externalReceiptCopiesChanged();

    void externalDeliveryChanged();

    void receiptPrinterChanged();
    void labelPrinterChanged();

    void reportsPrinterChanged();

    void receiptPaperSizeChanged();

    void reportsPaperSizeChanged();

    void receiptLinePrinterChanged();

    void receiptCopiesWithExternalDeliveryChanged();

    void labelPrinterLabelWidthChanged();

    void labelPrinterLabelHeightChanged();

    void labelPrinterLabelSizeUnitChanged();

    void testEnvChanged();

    void posReceiptBottomNoteChanged();

    void linePrinterChanged();

    void linePrinterPaperSizeChanged();

private:
    QString m_posReceiptBottomNote;
    bool m_testEnv=false;
    Q_PROPERTY(QByteArray jwt READ jwt WRITE setJwt NOTIFY jwtChanged)
    Q_PROPERTY(int receiptCopies READ receiptCopies WRITE setReceiptCopies NOTIFY receiptCopiesChanged)
    Q_PROPERTY(int externalReceiptCopies READ externalReceiptCopies WRITE setExternalReceiptCopies NOTIFY externalReceiptCopiesChanged)

    Q_PROPERTY(bool externalDelivery READ externalDelivery WRITE setExternalDelivery NOTIFY externalDeliveryChanged)

    Q_PROPERTY(bool receiptLinePrinter READ receiptLinePrinter WRITE setReceiptLinePrinter NOTIFY receiptLinePrinterChanged FINAL)
    Q_PROPERTY(int receiptCopiesWithExternalDelivery READ receiptCopiesWithExternalDelivery WRITE setReceiptCopiesWithExternalDelivery NOTIFY receiptCopiesWithExternalDeliveryChanged FINAL)

    Q_PROPERTY(float labelPrinterLabelWidth READ labelPrinterLabelWidth WRITE setLabelPrinterLabelWidth NOTIFY labelPrinterLabelWidthChanged FINAL)
    Q_PROPERTY(float labelPrinterLabelHeight READ labelPrinterLabelHeight WRITE setLabelPrinterLabelHeight NOTIFY labelPrinterLabelHeightChanged FINAL)
    Q_PROPERTY(int labelPrinterLabelSizeUnit READ labelPrinterLabelSizeUnit WRITE setLabelPrinterLabelSizeUnit NOTIFY labelPrinterLabelSizeUnitChanged FINAL)
    Q_PROPERTY(bool testEnv READ testEnv WRITE setTestEnv NOTIFY testEnvChanged FINAL)
    Q_PROPERTY(QString posReceiptBottomNote READ posReceiptBottomNote WRITE setPosReceiptBottomNote NOTIFY posReceiptBottomNoteChanged FINAL)
    Q_PROPERTY(QString linePrinter READ linePrinter WRITE setLinePrinter NOTIFY linePrinterChanged FINAL)
    Q_PROPERTY(QString linePrinterPaperSize READ linePrinterPaperSize WRITE setLinePrinterPaperSize NOTIFY linePrinterPaperSizeChanged FINAL)
};

#endif // APPSETTINGS_H
