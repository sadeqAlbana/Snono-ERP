#include "epsonprinter.h"
#include <QDebug>
EpsonPrinter::EpsonPrinter(QObject *parent)
    : QObject{parent}
{
    //qDebug()<<QSerialPortInfo::availablePorts().first().portName();
    m_serial.setBaudRate(QSerialPort::BaudRate::Baud9600);
    //m_serial.setDataBits(QSerialPort::Data8);
    //m_serial.setStopBits(QSerialPort::OneStop);
    //m_serial.setParity(QSerialPort::NoParity);
    m_serial.setPortName("COM1");
    qDebug()<<"open: "<<m_serial.open(QIODevice::OpenModeFlag::WriteOnly);
    //qDebug()<<m_serial.errorString();
    QThread::currentThread()->sleep(1);
    m_serial.write(QByteArray::fromRawData("\x1B\x33",2));
    qDebug()<<m_serial.waitForBytesWritten();
}
