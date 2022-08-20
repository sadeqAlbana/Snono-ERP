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

    Q_INVOKABLE static QString createNew(QJsonObject receiptData);

    Q_INVOKABLE static QString sampleData();

    Q_INVOKABLE static void printReceipt(QJsonObject receiptData);

signals:

private:



};

#endif // RECEIPTGENERATOR_H
