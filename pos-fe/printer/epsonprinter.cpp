#include "epsonprinter.h"

EpsonPrinter::EpsonPrinter(QObject *parent)
    : QObject{parent}
{
    m_serial.setBaudRate(QSerialPort::BaudRate::Baud9600);
    //m_serial.setDataBits(QSerialPort::Data8);
    //m_serial.setStopBits(QSerialPort::OneStop);
    //m_serial.setParity(QSerialPort::NoParity);
    m_serial.setPortName("/dev/ttyUSB0");
    qDebug()<<"open: "<<m_serial.open(QIODevice::OpenModeFlag::WriteOnly);
    qDebug()<<m_serial.errorString();
    m_serial.write("atesat");
}
