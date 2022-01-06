#include "receiptgenerator.h"
#include <QJsonObject>
#include <QImage>
#include <QPainter>
#include <QJsonArray>
#include <QPoint>
#include "utils.h"
#include <QBuffer>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRectF>
#include <QPrintDialog>
#include <QPrinter>
ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}


QImage ReceiptGenerator::create(QJsonObject receiptData)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();
    int height=400+((items.count()+1)*40)+200;

    QImage image(800,height,QImage::Format_RGB32);
    image.fill(Qt::white);
    QPainter painter(&image);
    QFont font=painter.font();
    font.setPixelSize(15);
    painter.setFont(font);
    QImage logo(":/images/icons/SheinIQ-circule.png");
    logo=logo.scaledToHeight(200);
    QPoint logoStart(centerStart(image.width(),logo.width()),20);
    painter.drawImage(logoStart,logo);


    //qDebug()<<"Test: "<<receiptData;
    QString reference=receiptData["reference"].toString();
    //qDebug()<<"Reference: " << reference;
    double taxAmount=receiptData["tax_amount"].toDouble();
    QString customer=receiptData["customers"].toObject()["name"].toString();
    QString address=receiptData["customers"].toObject()["address"].toString();
    double total=receiptData["total"].toDouble();
    QString phone=receiptData["customers"].toObject()["phone"].toString();
    QString date=receiptData["date"].toString();
    QDateTime dt=QDateTime::fromString(date,Qt::ISODate);
    painter.drawText(QRect(image.width()-620,240,  600,40),Qt::AlignRight,reference);
    painter.drawText(QRect(image.width()-420,280,  400,40),Qt::AlignRight,dt.date().toString(Qt::ISODate));
    painter.drawText(QRect(20,240, 600,40),Qt::AlignLeft,"Customer: " +customer);
    painter.drawText(QRect(20,280, 600,40),Qt::AlignLeft,"Address: " + address);
    painter.drawText(QRect(20,320, 600,40),Qt::AlignLeft,"Phone: "+phone);

    drawLine(painter,400,"No","Description","Price","Qty","Discount","Subtotal","Total");


    for(int i=0; i<items.size(); i++){
        QJsonObject item=items.at(i).toObject();
        QString description=item["products"].toObject()["name"].toString();
        QString unitPrice=Currency::formatString(item["unit_price"].toDouble());
        QString qty=QString::number(item["qty"].toDouble());
        QString discount=Currency::formatString(item["discount"].toDouble());

        QString subtotal=Currency::formatString(item["subtotal"].toDouble());
        QString total=Currency::formatString(item["total"].toDouble());
        drawLine(painter,(400+((i+1)*40)),QString::number(i+1),description,unitPrice,qty,discount,subtotal,total);

    }



    font.setPixelSize(25);
    painter.setFont(font);
    painter.drawText(QRect(20,image.height()-120, 600,40),Qt::AlignLeft,"Taxes: " + Currency::formatString(taxAmount));
    painter.drawText(QRect(20,image.height()-80, 600,40),Qt::AlignLeft, "Total: " +  Currency::formatString(total));


    return image;


    //image.save("/tmp/test.png");
}



int ReceiptGenerator::centerStart(int canvasWidth, int rectWidth)
{
    return (canvasWidth/2-(rectWidth/2));
}

void ReceiptGenerator::drawLine(QPainter &painter, const int &yAxis, const QString &no, const QString &description, const QString &price, const QString &qty, QString discount, const QString &subtotal, const QString &total)
{
    Q_UNUSED(no)
    //painter.drawText(QRect(20 ,yAxis, 60, 40),Qt::AlignCenter,no);
    QTextOption option;
    option.setAlignment(Qt::AlignHCenter | Qt::AlignTop);
    option.setWrapMode(QTextOption::WrapAtWordBoundaryOrAnywhere);
    painter.drawText(QRect(20 ,yAxis, 260,40),description,option);
    painter.drawText(QRect(280,yAxis, 100,40),price,option);
    painter.drawText(QRect(380,yAxis, 100,40),qty,option);
    painter.drawText(QRect(480,yAxis, 100,40),discount,option);
    painter.drawText(QRect(580,yAxis, 100,40),subtotal,option);
    painter.drawText(QRect(680,yAxis, 100,40),total,option);
}

QUrl ReceiptGenerator::imageToUrl(const QImage& image)
{
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "png");
    QString base64 = QString::fromUtf8(byteArray.toBase64());
    return QString("data:image/png;base64,") + base64;
}

QUrl ReceiptGenerator::generateReceiptUrl(QJsonObject receiptData)
{
    return imageToUrl(create(receiptData));
}

QUrl ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":42,"list_price":19087.5,"name":"SHEIN فستان نوم كامي زين تفاصيل حافة منديل شبكة - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return generateReceiptUrl(doc.object());

}

void ReceiptGenerator::printReceipt(QJsonObject receiptData)
{
    QPrinter printer;

    QPrintDialog *dlg = new QPrintDialog(&printer,0);

    if(dlg->exec() == QDialog::Accepted) {
            QPainter painter(&printer);
            painter.drawImage(QPoint(0,0),create(receiptData));
            painter.end();
    }
}
