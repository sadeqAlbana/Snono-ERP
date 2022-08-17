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

#include "code128item.h"
#include "qrcodegen.hpp"
//using namespace qrcodegen;
#include <vector>
#include <string>

#include <QSvgRenderer>
#include "code128.h"
#include <QGraphicsScene>
#include "utils.h"
#include <QTextDocument>
#include <QXmlStreamWriter>
#include <QFile>
#include <QTranslator>
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
    for(int i=0; i<barcode.length(); i++){
        encoded.append((char)barcode.at(i));
    }
    painter.setFont(barcodefont);

    painter.drawText(20,100,encoded);






    painter.end();//?

}

QString ReceiptGenerator::createNew(QJsonObject receiptData)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();

    QImage logo(":/images/icons/SheinIQ-circule.png");


    int orderId=receiptData["id"].toInt();
    QString reference=QString("No. %1").arg(orderId);
    double taxAmount=receiptData["tax_amount"].toDouble();
    QString customer=receiptData["customers"].toObject()["name"].toString();
    QString address=receiptData["customers"].toObject()["address"].toString();
    double total=receiptData["total"].toDouble();
    QString phone=receiptData["customers"].toObject()["phone"].toString();
    QString date=receiptData["date"].toString();
    QDateTime dt=QDateTime::fromString(date,Qt::ISODate);
    QString note=receiptData["note"].toString();
    double totalWithDelivery=0;
    double deliveryFee=0;
    if(receiptData.contains("external_delivery")){
        deliveryFee=receiptData["external_delivery"].toDouble();
        totalWithDelivery=total+deliveryFee;
    }



    //painter.drawPixmap(QRect(20,20,180,180),qrPixmap);

        const QString baseName = "pos-fe_" + QLocale("ar-IQ").name();
        QTranslator *translator= new QTranslator(); //memory leak !
        translator->load(":/i18n/" + baseName);




    QTextDocument doc;

    QFile file(":/receipt/style.css");
    qDebug()<<"file open: " <<file.open(QIODevice::ReadOnly);
    QByteArray css=file.readAll();
    file.close();
    doc.setDefaultStyleSheet(css);

    doc.addResource(QTextDocument::ImageResource,QUrl("logo_image"),logo);

    qrcodegen::QrCode qr0 = qrcodegen::QrCode::encodeText(QString::number(orderId).toStdString().c_str(), qrcodegen::QrCode::Ecc::MEDIUM);
    std::string svgString = QrCode::toSvgString(qr0, 0);  // See QrCodeGeneratorDemo


    QSvgRenderer svg(QByteArray::fromStdString(svgString));
    QPixmap qrPixmap(750,750);
    QPainter qrPainter(&qrPixmap);
    svg.render(&qrPainter);
    qrPainter.end();

    doc.addResource(QTextDocument::ImageResource,QUrl("qr_code"),qrPixmap);

    QImage barcodeImg(200,80,QImage::Format_RGB32);
    barcodeImg.fill(Qt::white);
    QPainter imgPainter(&barcodeImg);
    Code128Item item;
    item.setPos(0,0);
    item.setWidth( barcodeImg.width() );
    item.setHeight( barcodeImg.height() );
    item.setText(QString::number(orderId));
    item.update();
    item.paint(&imgPainter,nullptr,nullptr);
    imgPainter.end();


    doc.addResource(QTextDocument::ImageResource,QUrl("barcode_img"),barcodeImg);

    QString text;
    QXmlStreamWriter stream(&text);
    QStringList headers{tr("Item"),tr("Price"),tr("Qty"),tr("Disc."),tr("Subtotal"),tr("Total")};
    stream.setAutoFormatting(true);
    stream.writeStartDocument();
    stream.writeStartElement("html");
//    stream.writeAttribute("dir","rtl");
//    stream.writeAttribute("lang","ar");
    stream.writeStartElement("head");
//    stream.writeTextElement("style",css);
    stream.writeEndElement(); //head

        stream.writeStartElement("body");
            stream.writeStartElement("table");
            stream.writeAttribute("width","100%");
                stream.writeStartElement("tr");

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","32%");
                    stream.writeAttribute("style","vertical-align: middle;");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","75");
                            stream.writeAttribute("height","75");
                            stream.writeAttribute("src", "qr_code");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","36%");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","100");
                            stream.writeAttribute("height","100");
                            stream.writeAttribute("src", "logo_image");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","32%");
                    stream.writeAttribute("style","vertical-align: middle;");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","100");
                            stream.writeAttribute("height","40");
                            stream.writeAttribute("src", "barcode_img");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                stream.writeEndElement(); //tr

            stream.writeEndElement(); //table






            stream.writeStartElement("table");
            stream.writeAttribute("class","boxed");

            stream.writeAttribute("style", "width: 100%;");
                stream.writeStartElement("tbody");
                stream.writeAttribute("class","boxed");

                stream.writeStartElement("tr");
                stream.writeAttribute("class","boxed");
                    stream.writeStartElement("th");
                    stream.writeAttribute("class","boxed");
                    stream.writeAttribute("width","25%");
                    stream.writeCharacters(tr("No."));
                    stream.writeEndElement(); //th
                    stream.writeStartElement("td");
                    stream.writeAttribute("class","boxed");
                    stream.writeAttribute("width","75%");
                    stream.writeCharacters(QString::number(orderId));
                    stream.writeEndElement(); //td
                stream.writeEndElement(); //tr

                    stream.writeStartElement("tr");
                    stream.writeAttribute("class","boxed");
                        stream.writeStartElement("th");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(tr("Date"));
                        stream.writeEndElement(); //th
                        stream.writeStartElement("td");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","75%");
                        stream.writeCharacters(dt.date().toString(Qt::ISODate));
                        stream.writeEndElement(); //td
                    stream.writeEndElement(); //tr

                    stream.writeStartElement("tr");
                    stream.writeAttribute("class","boxed");
                        stream.writeStartElement("th");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(tr("Name:"));
                        stream.writeEndElement(); //th
                        stream.writeStartElement("td");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","75%");
                        stream.writeCharacters(customer);
                        stream.writeEndElement(); //td
                    stream.writeEndElement(); //tr

                    stream.writeStartElement("tr");
                    stream.writeAttribute("class","boxed");
                        stream.writeStartElement("th");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(tr("Address"));
                        stream.writeEndElement(); //th
                        stream.writeStartElement("td");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","75%");
                        stream.writeCharacters(address);
                        stream.writeEndElement(); //td
                    stream.writeEndElement(); //tr

                    stream.writeStartElement("tr");
                    stream.writeAttribute("class","boxed");
                        stream.writeStartElement("th");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(tr("Phone"));
                        stream.writeEndElement(); //th
                        stream.writeStartElement("td");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","75%");
                        stream.writeCharacters(phone);
                        stream.writeEndElement(); //td
                    stream.writeEndElement(); //tr

                    stream.writeStartElement("tr");
                    stream.writeAttribute("class","boxed");
                        stream.writeStartElement("th");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(tr("Notes"));
                        stream.writeEndElement(); //th
                        stream.writeStartElement("td");
                        stream.writeAttribute("class","boxed");
                        stream.writeAttribute("width","75%");
                        stream.writeCharacters(note);
                        stream.writeEndElement(); //td
                    stream.writeEndElement(); //tr


                stream.writeEndElement(); //tbody
            stream.writeEndElement(); //table

            stream.writeStartElement("h2");
            stream.writeAttribute("align","center");
            stream.writeCharacters("Original Receipt");
            stream.writeEndElement(); //h2




     stream.writeStartElement("table");
     stream.writeAttribute("style", "width: 100%;");
     stream.writeAttribute("class", "items");

         stream.writeStartElement("thead");
             stream.writeStartElement("tr");
                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","25%");
                     stream.writeCharacters(tr("Item"));
                     stream.writeEndElement(); //th

                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","15%");
                     stream.writeCharacters(tr("Price"));
                     stream.writeEndElement(); //th

                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","10%");
                     stream.writeCharacters(tr("Qty"));
                     stream.writeEndElement(); //th

                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","10%");
                     stream.writeCharacters(tr("Disc."));
                     stream.writeEndElement(); //th

                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","20%");
                     stream.writeCharacters(tr("Subtotal"));
                     stream.writeEndElement(); //th

                     stream.writeStartElement("th");
                     stream.writeAttribute("class","heading");
                     stream.writeAttribute("width","20%");
                     stream.writeCharacters(tr("Total"));
                     stream.writeEndElement(); //th
                 stream.writeEndElement(); //tr
         stream.writeEndElement(); //thead
         stream.writeStartElement("tbody");


         for(int i=0; i<items.size(); i++){
             stream.writeStartElement("tr");
             QJsonObject item=items.at(i).toObject();
             QString description=item["products"].toObject()["name"].toString();
             QString unitPrice=Currency::formatString(item["unit_price"].toDouble());
             QString qty=QString::number(item["qty"].toDouble());
             QString discount=QString::number(item["discount"].toDouble())+"%";

             QString subtotal=Currency::formatString(item["subtotal"].toDouble());
             QString total=Currency::formatString(item["total"].toDouble());

             stream.writeTextElement("td",description);
             stream.writeTextElement("td", unitPrice);
             stream.writeTextElement("td", qty);
             stream.writeTextElement("td", discount);
             stream.writeTextElement("td", subtotal);
             stream.writeTextElement("td", total);
             stream.writeEndElement(); //tr

         }

         //receipt totals
         stream.writeStartElement("tr");
            stream.writeStartElement("th");
            stream.writeAttribute("class","line left");
            stream.writeCharacters("Delivery");
            stream.writeEndElement(); //th

            stream.writeStartElement("th");
            stream.writeAttribute("class","line left");
            stream.writeAttribute("colspan","5");
            stream.writeCharacters(Currency::formatString(deliveryFee));
            stream.writeEndElement(); //th
         stream.writeEndElement(); //tr

         stream.writeStartElement("tr");
            stream.writeStartElement("th");
            stream.writeAttribute("class","dashed left");
            stream.writeCharacters("Total");
            stream.writeEndElement(); //th

            stream.writeStartElement("th");
            stream.writeAttribute("class","dashed left");
            stream.writeAttribute("colspan","5");
            stream.writeCharacters(Currency::formatString(total));
            stream.writeEndElement(); //th
         stream.writeEndElement(); //tr

         stream.writeStartElement("tr");
            stream.writeStartElement("th");
            stream.writeAttribute("class","dashed-bottom left");
            stream.writeCharacters("Total + Delivery");
            stream.writeEndElement(); //th

            stream.writeStartElement("th");
            stream.writeAttribute("class","dashed-bottom left");
            stream.writeAttribute("colspan","5");
            stream.writeCharacters(Currency::formatString(totalWithDelivery));
            stream.writeEndElement(); //th
         stream.writeEndElement(); //tr
         stream.writeEndElement(); //tbody
     stream.writeEndElement(); //table


     stream.writeStartElement("section");
     stream.writeEmptyElement("br");
     stream.writeEndElement(); //section

     stream.writeStartElement("footer");
     stream.writeAttribute("style","text-align:center");

     stream.writeStartElement("p");
     stream.writeAttribute("class","receipt");
     stream.writeCharacters(tr("Thank you for chosing Shein IQ"));
     stream.writeEndElement(); //p

     stream.writeStartElement("p");
     stream.writeAttribute("class","receipt");
     stream.writeCharacters("fb.com/sheiniq");
     stream.writeEndElement(); //p

     stream.writeEndElement(); //footer

     stream.writeEndElement(); //body
     stream.writeEndElement(); //html
     stream.writeEndDocument(); //doc


     doc.setPageSize(QPageSize(QPageSize::A5).sizePoints());
     doc.setHtml(text);

     QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
//     printer.setPageMargins(QMarginsF(0,0,0,0));
//     printer.setFullPage(true);
     printer.setPageSize(QPageSize(QPageSize::A5));
     doc.print(&printer);


     return doc.toHtml();

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

QString ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":993,"list_price":19087.5,"name":"312 - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return createNew(doc.object());

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


