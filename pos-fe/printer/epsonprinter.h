#ifndef EPSONPRINTER_H
#define EPSONPRINTER_H

#include <QObject>
#include <QtSerialPort>
class EpsonPrinter : public QObject
{
    Q_OBJECT
public:
    explicit EpsonPrinter(QObject *parent = nullptr);

signals:

private:
    QSerialPort m_serial;
};

#endif // EPSONPRINTER_H
