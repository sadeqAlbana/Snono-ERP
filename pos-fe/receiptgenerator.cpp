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
#include <QPrinterInfo>

#include "qrcodegen.hpp"
//using namespace qrcodegen;
#include <vector>
#include <string>

#include <QSvgRenderer>
#include "code128.h"
#include <QGraphicsScene>
#include "utils.h"


ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}


void ReceiptGenerator::create(QJsonObject receiptData, QPaintDevice *device, int scaleFactor)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();
    int height=receiptHeight(receiptData);
    int width=575;

    QPainter painter(device);
    if(scaleFactor>1)
    painter.scale(scaleFactor,scaleFactor);
    painter.setPen(Qt::black);
    QFont font=painter.font();
    font.setPixelSize(17);
    painter.setFont(font);
    QImage logo(":/images/icons/SheinIQ-circule.png");
    logo=logo.scaledToHeight(200);
    QPoint logoStart(centerStart(width,logo.width()),20);
    painter.drawImage(logoStart,logo);


    //qDebug()<<"Test: "<<receiptData;
    int orderId=receiptData["id"].toInt();
    QString reference=QString("No. %1").arg(orderId);
    //qDebug()<<"Reference: " << reference;
    double taxAmount=receiptData["tax_amount"].toDouble();
    QString customer=receiptData["customers"].toObject()["name"].toString();
    QString address=receiptData["customers"].toObject()["address"].toString();
    double total=receiptData["total"].toDouble();
    QString phone=receiptData["customers"].toObject()["phone"].toString();
    QString date=receiptData["date"].toString();
    QDateTime dt=QDateTime::fromString(date,Qt::ISODate);
    QString note=receiptData["note"].toString();
    painter.drawText(QRect(width-620,240,  600,40),Qt::AlignRight,reference);
    painter.drawText(QRect(width-420,280,  400,40),Qt::AlignRight,dt.date().toString(Qt::ISODate));
    painter.drawText(QRect(width-620,320,  600,40),Qt::AlignRight,note);

    painter.drawText(QRect(20,240, 600,40),Qt::AlignLeft,"Customer: " +customer);
    painter.drawText(QRect(20,280, 600,40),Qt::AlignLeft,"Address: " + address);
    painter.drawText(QRect(20,320, 600,40),Qt::AlignLeft,"Phone: "+phone);

    drawLine(painter,400,"No","Description","Price","Qty","Disc.","Subtotal","Total");


    for(int i=0; i<items.size(); i++){
        QJsonObject item=items.at(i).toObject();
        QString description=item["products"].toObject()["name"].toString();
        QString unitPrice=Currency::formatString(item["unit_price"].toDouble());
        QString qty=QString::number(item["qty"].toDouble());
        QString discount=QString::number(item["discount"].toDouble())+"%";

        QString subtotal=Currency::formatString(item["subtotal"].toDouble());
        QString total=Currency::formatString(item["total"].toDouble());
        drawLine(painter,(400+((i+1)*55)),QString::number(i+1),description,unitPrice,qty,discount,subtotal,total);

    }



    font.setPixelSize(25);
    painter.setFont(font);
    painter.drawText(QRect(20,height-220, 600,40),Qt::AlignLeft,"Taxes: " + Currency::formatString(taxAmount));
    painter.drawText(QRect(20,height-180, 600,40),Qt::AlignLeft, "Total: " +  Currency::formatString(total));

    if(receiptData.contains("external_delivery")){
        double totalWithDelivery=total+receiptData["external_delivery"].toDouble();
        painter.drawText(QRect(20,height-140, 600,40),Qt::AlignLeft, "Total With Delivery: " +  Currency::formatString(totalWithDelivery));

    }

    font.setPixelSize(22);
    font.setBold(true);

    painter.setFont(font);
    painter.drawText(QRect(0,height-80, 575,40),Qt::AlignCenter, "رقم المتجر");
    painter.drawText(QRect(0,height-40, 575,40),Qt::AlignCenter, "0783 666 5444");

    qrcodegen::QrCode qr0 = qrcodegen::QrCode::encodeText(QString::number(orderId).toStdString().c_str(), qrcodegen::QrCode::Ecc::MEDIUM);
    std::string svgString = QrCode::toSvgString(qr0, 4);  // See QrCodeGeneratorDemo

//    QSvgRenderer svg(QByteArray::fromStdString(svgString));
//    QPixmap qrPixmap(180,180);
//    QPainter qrPainter(&qrPixmap);
//    svg.render(&qrPainter);
//    qrPainter.end();
//    painter.drawPixmap(QRect(20,20,180,180),qrPixmap);




    QFont barcodefont = QFont("Code 128", 46, QFont::Normal);
    barcodefont.setLetterSpacing(QFont::AbsoluteSpacing,0.0);


    Code128::BarCode barcode=Code128::encode("1");

    QString encoded;
    for(int i=0; i<barcode.length(); i++)
    encoded.append((char)barcode.at(i));
    painter.setFont(barcodefont);

    painter.drawText(20,100,encoded);



//    Code128Item item;
//    painter.setFont(QFont());
//    item.setPos(0,0);
//    item.setWidth( 200 );
//    item.setHeight( 80 );
//    item.setText("1");
//    item.update();
//    item.paint(&painter,nullptr,nullptr);


    painter.end();//?

}

int ReceiptGenerator::receiptHeight(const QJsonObject &receiptData)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();
    int height= 400+((items.count()+1)*55)+300;

    if(receiptData.contains("external_delivery"))
        height+=40;
    return height;
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
    painter.drawText(QRect(0 ,yAxis, 175,40),description,option);
    painter.drawText(QRect(175,yAxis, 100,40),price,option);
    painter.drawText(QRect(275,yAxis, 50,40),qty,option);
    painter.drawText(QRect(325,yAxis, 50,40),discount,option);
    painter.drawText(QRect(375,yAxis, 100,40),subtotal,option);
    painter.drawText(QRect(475,yAxis, 100,40),total,option);
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
    return imageToUrl(generateImage(receiptData));
}

QImage ReceiptGenerator::generateImage(QJsonObject receiptData)
{
    QImage image(575,receiptHeight(receiptData),QImage::Format_RGB32);
    image.fill(Qt::white);
    create(receiptData,&image);
    return image;
}

QUrl ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":993,"list_price":19087.5,"name":"SHEIN فستان نوم كامي زين تفاصيل حافة منديل شبكة - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return generateReceiptUrl(doc.object());

}

void ReceiptGenerator::printReceipt(QJsonObject receiptData)
{
    QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
    printer.setPageMargins(QMarginsF(0,0,0,0));

    QImage image(575*10,receiptHeight(receiptData)*10,QImage::Format_Grayscale16);
    image.fill(Qt::white);
    printer.setPageSize(QPageSize::A5);
    printer.setCopyCount(3);
    //printer.setFullPage(true);


    //qDebug()<<QPrinterInfo::defaultPrinter().printerName();
    create(receiptData,&image,10);

    QPainter painter(&printer);
    image=image.scaledToHeight(printer.height()*0.9,Qt::SmoothTransformation);
    painter.drawImage((printer.width()-image.width())/2,0,image);
    painter.end();
}


