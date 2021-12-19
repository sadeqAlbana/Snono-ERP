#ifndef RECEIPTGENERATOR_H
#define RECEIPTGENERATOR_H

#include <QObject>
class QPainter;
class ReceiptGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ReceiptGenerator(QObject *parent = nullptr);

    static void create(QJsonObject receiptData);

    static int centerStart(int canvasWidth, int rectWidth);

    static void drawLine(QPainter &painter,const int &yAxis,const QString &no, const QString &description, const QString &price,
                  const QString &qty, const QString &subtotal, const QString &total);

signals:

};

#endif // RECEIPTGENERATOR_H
