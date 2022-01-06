#ifndef RECEIPTGENERATOR_H
#define RECEIPTGENERATOR_H

#include <QObject>
#include <QUrl>
#include <QJsonObject>
class QPainter;
class ReceiptGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ReceiptGenerator(QObject *parent = nullptr);

    static QImage create(QJsonObject receiptData);

    static int centerStart(int canvasWidth, int rectWidth);

    static void drawLine(QPainter &painter, const int &yAxis, const QString &no, const QString &description, const QString &price,
                  const QString &qty, QString discount, const QString &subtotal, const QString &total);


    static QUrl imageToUrl(const QImage& image);

    Q_INVOKABLE static QUrl generateReceiptUrl(QJsonObject receiptData);
    Q_INVOKABLE static QUrl sampleData();

    Q_INVOKABLE static void printReceipt(QJsonObject receiptData);

signals:

};

#endif // RECEIPTGENERATOR_H
