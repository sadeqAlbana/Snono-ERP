#ifndef RECEIPTGENERATOR_H
#define RECEIPTGENERATOR_H

#include <QObject>
#include <QUrl>
#include <QJsonObject>
#include <QImage>
class QPainter;
class QPrinter;
#define CODE128_B_START 104
#define CODE128_STOP 106
#include <QTextDocument>
class ReceiptGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ReceiptGenerator(QObject *parent = nullptr);

    static void create(QJsonObject receiptData, QPaintDevice *device,int scaleFactor=1);
    Q_INVOKABLE static QString createNew(QJsonObject receiptData);

    static int receiptHeight(const QJsonObject &receiptData);

    static int centerStart(int canvasWidth, int rectWidth);

    static void drawLine(QPainter &painter, const int &yAxis, const QString &no, const QString &description, const QString &price,
                  const QString &qty, QString discount, const QString &subtotal, const QString &total);


    static QUrl imageToUrl(const QImage& image);

    Q_INVOKABLE static QUrl generateReceiptUrl(QJsonObject receiptData);
    Q_INVOKABLE static QImage generateImage(QJsonObject receiptData);

    Q_INVOKABLE static QString sampleData();

    Q_INVOKABLE static void printReceipt(QJsonObject receiptData);

signals:

private:



};

#endif // RECEIPTGENERATOR_H
