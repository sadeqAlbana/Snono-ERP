#ifndef RECEIPTGENERATOR_H
#define RECEIPTGENERATOR_H

#include <QObject>
#include <QUrl>
#include <QJsonObject>
#include <QImage>
class QPainter;
class QPrinter;

#include <QTextDocument>
class ReceiptGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ReceiptGenerator(QObject *parent = nullptr);

    Q_INVOKABLE static QString createDeliveryReceipt(QJsonObject receiptData, const bool print=false);
    Q_INVOKABLE static QString createCashierReceipt(QJsonObject receiptData, const bool print=false);

    Q_INVOKABLE static QString generateSheinOrderManifestLabel(const QString &orderNo, const QVariantList &trackingsNumbers);
    Q_INVOKABLE static QString generateOrderReferenceAndTrackings(const QString &orderNo, const QStringList &trackingNumbers);


    Q_INVOKABLE static QString generateLabel(const QString &barcode, const QString &name, const QString &price, const QString &sku=QString(), const int copies=1);


    Q_INVOKABLE static QImage renderToImage(QTextDocument &doc, const int scaleFactor=1);
    Q_INVOKABLE static QString sampleData();

signals:

private:



};

#endif // RECEIPTGENERATOR_H
