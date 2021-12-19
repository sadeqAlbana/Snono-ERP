#include "receiptgenerator.h"
#include <QJsonObject>
#include <QImage>
#include <QPainter>
#include <QJsonArray>
#include <QPoint>
#include "utils.h"
ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}



void ReceiptGenerator::create(QJsonObject receiptData)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();
    int height=400+200+((items.count()+1)*40)+400;

    QImage image(800,height,QImage::Format_RGB32);
    image.fill(Qt::white);
    QPainter painter(&image);

    QImage logo(":/images/icons/SheinIQ.png");
    logo=logo.scaledToHeight(200);
    QPoint logoStart(centerStart(image.width(),logo.width()),20);
    painter.drawImage(logoStart,logo);

    //qDebug()<<"Test: "<<receiptData;
    QString reference=receiptData["reference"].toString();
    //qDebug()<<"Reference: " << reference;
    double taxAmount=receiptData["tax_amount"].toDouble();
    QString customer=receiptData["customers"].toObject()["first_name"].toString();
    QString address=receiptData["customers"].toObject()["address"].toString();
    double total=receiptData["total"].toDouble();
    QString phone=receiptData["customers"].toObject()["phone"].toString();
    QString date=receiptData["date"].toString();
    QDateTime dt=QDateTime::fromString(date,Qt::ISODate);

    painter.drawText(QRect(10,20,  600,40),Qt::AlignLeft,reference);
    painter.drawText(QRect(10,60,  600,40),Qt::AlignLeft,dt.date().toString(Qt::ISODate));
    painter.drawText(QRect(10,100, 600,40),Qt::AlignLeft,customer);
    painter.drawText(QRect(10,140, 600,40),Qt::AlignLeft,address);
    painter.drawText(QRect(10,180, 600,40),Qt::AlignLeft,phone);
    painter.drawText(QRect(10,220, 600,40),Qt::AlignLeft,Currency::formatString(total));
    painter.drawText(QRect(10,260, 600,40),Qt::AlignLeft,Currency::formatString(taxAmount));

    drawLine(painter,400,"No","Description","Price","Qty","Subtotal","Total");


    for(int i=0; i<items.size(); i++){
        QJsonObject item=items.at(i).toObject();
        QString description=item["products"].toObject()["name"].toString();
        QString unitPrice=QString::number(item["unit_price"].toDouble());
        QString qty=QString::number(item["qty"].toDouble());
        QString subtotal=QString::number(item["subtotal"].toDouble());
        QString total=QString::number(item["total"].toDouble());
        drawLine(painter,(400+((i+1)*40)),QString::number(i+1),description,unitPrice,qty,subtotal,total);

    }




    image.save("/tmp/test.png");
}



int ReceiptGenerator::centerStart(int canvasWidth, int rectWidth)
{
    return (canvasWidth/2-(rectWidth/2));
}

void ReceiptGenerator::drawLine(QPainter &painter, const int &yAxis, const QString &no, const QString &description, const QString &price, const QString &qty, const QString &subtotal, const QString &total)
{
    painter.drawText(QRect(20 ,yAxis, 60, 40),Qt::AlignCenter,no);
    painter.drawText(QRect(80 ,yAxis, 300,40),Qt::AlignCenter,description);
    painter.drawText(QRect(380,yAxis, 100,40),Qt::AlignCenter,price);
    painter.drawText(QRect(480,yAxis, 100,40),Qt::AlignCenter,qty);
    painter.drawText(QRect(580,yAxis, 100,40),Qt::AlignCenter,subtotal);
    painter.drawText(QRect(680,yAxis, 100,40),Qt::AlignCenter,total);
}
