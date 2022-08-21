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
#include <QRandomGenerator64>
#include "qrcodegen.hpp"
//using namespace qrcodegen;
#include <vector>
#include <string>

#include <QSvgRenderer>
#include <QGraphicsScene>
#include "utils.h"
#include <QTextDocument>
#include <QXmlStreamWriter>
#include <QFile>
#include <QTranslator>
#include <QApplication>
#include <QStandardPaths>
#include <QPdfDocument>
#include <algorithm>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QVariant>
ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}




QString ReceiptGenerator::createNew(QJsonObject receiptData, const bool print)
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
    double totalWithDelivery=total;
    double deliveryFee=0;
    if(receiptData.contains("external_delivery")){
        deliveryFee=receiptData["external_delivery"].toDouble();
        totalWithDelivery=total+deliveryFee;
    }



    //painter.drawPixmap(QRect(20,20,180,180),qrPixmap);

        const QString baseName = "pos-fe_" + QLocale("ar-IQ").name();
        qDebug()<<"Base name: " << baseName;
        QTranslator translator;
        qDebug()<<"translator load: "<< translator.load(":/i18n/" + baseName);

        bool rtl=true;




    QTextDocument doc;

    QFile file(":/receipt/style.css");
    qDebug()<<"file open: " <<file.open(QIODevice::ReadOnly);
    QByteArray css=file.readAll();
    file.close();
    //doc.setDefaultStyleSheet(css);

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


    QList<QJsonObject> rtable{
        QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")},{"width","25%"}},
        QJsonObject{{"key","price"},{"label",translator.translate("receipt","Price")},{"width","15%"}},
        QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")},{"width","10%"}},
        QJsonObject{{"key","discount"},{"label",translator.translate("receipt","Disc.")},{"width","10%"}},
        QJsonObject{{"key","subtotal"},{"label",translator.translate("receipt","Subtotal")},{"width","20%"}},
        QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")},{"width","20%"}},
    };

    if(rtl){
        std::reverse(rtable.begin(),rtable.end());
    }
    QString text;
    QXmlStreamWriter stream(&text);
    stream.setAutoFormatting(true);
    stream.writeStartDocument();
    stream.writeStartElement("html");
    if(rtl){
        stream.writeAttribute("dir","rtl");
    }
//    stream.writeAttribute("lang","ar");
    stream.writeStartElement("head");
    stream.writeTextElement("style",css);
    stream.writeEndElement(); //head

        stream.writeStartElement("body");
            stream.writeStartElement("table");
            stream.writeAttribute("width","100%");
                stream.writeStartElement("tr");

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","32%");
                    stream.writeAttribute("style","vertical-align: middle;");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","50");
                            stream.writeAttribute("height","50");
                            stream.writeAttribute("src", "qr_code");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","36%");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","75");
                            stream.writeAttribute("height","75");
                            stream.writeAttribute("src", "logo_image");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                    stream.writeStartElement("th");
                    stream.writeAttribute("width","32%");
                    stream.writeAttribute("style","vertical-align: middle;");
                            stream.writeStartElement("img");
                            stream.writeAttribute("width","75");
                            stream.writeAttribute("height","30");
                            stream.writeAttribute("src", "barcode_img");
                            stream.writeEndElement(); //img
                    stream.writeEndElement(); //th

                stream.writeEndElement(); //tr

            stream.writeEndElement(); //table






            stream.writeStartElement("table");
            stream.writeAttribute("class","boxed center");

            stream.writeAttribute("style", "width: 100%;");
                stream.writeStartElement("tbody");
                stream.writeAttribute("class","boxed");

                stream.writeStartElement("tr");
                stream.writeAttribute("class","boxed");
                    stream.writeStartElement("th");
                    stream.writeAttribute("class","boxed center-align");
                    stream.writeAttribute("width","25%");
                    stream.writeCharacters(translator.translate("receipt","No."));
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
                        stream.writeAttribute("class","boxed center-align");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(translator.translate("receipt","Date"));
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
                        stream.writeAttribute("class","boxed center-align");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(translator.translate("receipt","Name"));
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
                        stream.writeAttribute("class","boxed center-align");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(translator.translate("receipt","Address"));
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
                        stream.writeAttribute("class","boxed center-align");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(translator.translate("receipt","Phone"));
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
                        stream.writeAttribute("class","boxed center-align");
                        stream.writeAttribute("width","25%");
                        stream.writeCharacters(translator.translate("receipt","Notes"));
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
            stream.writeCharacters(translator.translate("receipt","Original Receipt"));
            stream.writeEndElement(); //h2




     stream.writeStartElement("table");
     stream.writeAttribute("style", "width: 100%;");
     stream.writeAttribute("class", "items");

         stream.writeStartElement("thead");
             stream.writeStartElement("tr");
             for(int i=0; i<rtable.count(); i++){
                 QJsonObject column=rtable.at(i);
                 stream.writeStartElement("th");
                 stream.writeAttribute("class","heading");
                 stream.writeAttribute("width",column["width"].toString());
                 stream.writeCharacters(column["label"].toString());
                 stream.writeEndElement(); //th
             }
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

             QJsonObject tableRow{{"description",description},
                                  {"unitPrice",unitPrice},{"qty",qty},{"discount",discount},
                                  {"subtotal",subtotal},{"total",total}};

             for(int i=0;i<rtable.count(); i++){
                 QJsonObject column=rtable.at(i);
                 stream.writeTextElement("td",tableRow[column["key"].toString()].toString());

             }
             stream.writeEndElement(); //tr

         }

         //receipt totals

         QList<QJsonObject> totals{
             {{"label",translator.translate("receipt","Total")}},
             {{"label",Currency::formatString(total)},{"colspan",5}}
         };

         QList<QJsonObject> totalsWidthDelivery{
             {{"label",translator.translate("receipt","Total + Delivery")}},
             {{"label",Currency::formatString(totalWithDelivery)},{"colspan",5}}
         };

         stream.writeStartElement("tr");
            stream.writeStartElement("th");
            stream.writeAttribute("class","dashed left");
            stream.writeCharacters(translator.translate("receipt","Total"));
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
            stream.writeCharacters(translator.translate("receipt","Total + Delivery"));
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
     stream.writeCharacters(translator.translate("receipt","Thank you for choosing Shein IQ"));
     stream.writeEndElement(); //p

     stream.writeStartElement("p");
     stream.writeAttribute("class","receipt");
     stream.writeCharacters("fb.com/sheiniq");
     stream.writeEndElement(); //p

     stream.writeStartElement("p");
     stream.writeAttribute("class","receipt");
     stream.writeCharacters(translator.translate("receipt","Please Return each item to it's original bag"));
     stream.writeEndElement(); //p


     stream.writeStartElement("table");
     stream.writeAttribute("width","100%");
         stream.writeStartElement("tr");

             stream.writeStartElement("th");
             stream.writeAttribute("width","32%");
             stream.writeAttribute("style","vertical-align: middle;");
                     stream.writeStartElement("img");
                     stream.writeAttribute("width","50");
                     stream.writeAttribute("height","50");
                     stream.writeAttribute("src", "qr_code");
                     stream.writeEndElement(); //img
             stream.writeEndElement(); //th

             stream.writeStartElement("th");
             stream.writeAttribute("width","36%");

             stream.writeEndElement(); //th

             stream.writeStartElement("th");
             stream.writeAttribute("width","32%");
             stream.writeAttribute("style","vertical-align: middle;");
                     stream.writeStartElement("img");
                     stream.writeAttribute("width","75");
                     stream.writeAttribute("height","30");
                     stream.writeAttribute("src", "barcode_img");
                     stream.writeEndElement(); //img
             stream.writeEndElement(); //th

         stream.writeEndElement(); //tr

     stream.writeEndElement(); //table



     stream.writeEndElement(); //footer

     stream.writeEndElement(); //body
     stream.writeEndElement(); //html
     stream.writeEndDocument(); //doc


     doc.setPageSize(QPageSize(QPageSize::A5).sizePoints());
     doc.setHtml(text);

//     QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
////     printer.setPageMargins(QMarginsF(0,0,0,0));
////     printer.setFullPage(true);
//     printer.setPageSize(QPageSize(QPageSize::A5));
//     doc.print(&printer);

     QPrinter pdfPrinter(QPrinter::HighResolution);
     pdfPrinter.setOutputFormat(QPrinter::OutputFormat::PdfFormat);
     QString random=QString::number(QRandomGenerator::global()->generate());
     pdfPrinter.setOutputFileName(QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0)+QString("/%1.pdf").arg(random));
     qDebug()<<"path: " <<pdfPrinter.outputFileName();
     doc.print(&pdfPrinter);

     if(print){
         QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
         printer.setCopyCount(3);
         printer.setPageSize(QPageSize::A5);
         doc.print(&printer);
     }



     return pdfPrinter.outputFileName();
}







QString ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":993,"list_price":19087.5,"name":"312 - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return createNew(doc.object());

}



