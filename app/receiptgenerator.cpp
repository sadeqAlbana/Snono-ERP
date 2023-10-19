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
#ifndef Q_OS_IOS
#include <QPrintDialog>
#endif
#include <QPrinter>
#include <QPrinterInfo>
#include "code128item.h"
#include <QRandomGenerator64>
#include "qrcodegen.hpp"
#include <vector>
#include <string>
#include <QSvgRenderer>
#include <QGraphicsScene>
#include "utils.h"
#include <QTextDocument>
#include <QXmlStreamWriter>
#include <QFile>
#include <QTranslator>
#include <QStandardPaths>

#include <algorithm>
#include "appsettings.h"
ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}




QString ReceiptGenerator::createNew(QJsonObject receiptData, const bool print)
{
    QJsonArray items=receiptData["pos_order_items"].toArray();

    QImage logo(AppSettings::storagePath()+"/assets/receipt_logo.png");



    int orderId=receiptData["id"].toInt();
    QString reference=QString("No. %1").arg(orderId);

    QJsonArray orderAttributes=receiptData["attributes"].toArray();
    QString externalDeliveryId;
    for(auto value : orderAttributes){
        QJsonObject orderAttribute=value.toObject();
        if(orderAttribute["id"].toString()=="external_delivery_id"){
            externalDeliveryId=orderAttribute["value"].toString();
        }
    }
    qDebug()<<receiptData["attributes"];
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
    QPixmap qrPixmap(1500,1500);
    QPainter qrPainter(&qrPixmap);
    svg.render(&qrPainter);
    qrPainter.end();

    doc.addResource(QTextDocument::ImageResource,QUrl("qr_code"),qrPixmap);

    QImage barcodeImg(400,160,QImage::Format_RGB32);
    barcodeImg.fill(Qt::white);
    QPainter imgPainter(&barcodeImg);
    Code128Item item;
#ifndef Q_OS_IOS
    item.setPos(0,0);
#endif
    item.setWidth( barcodeImg.width() );
    item.setHeight( barcodeImg.height() );
    item.setText(QString::number(orderId));

#ifndef Q_OS_IOS
    item.update();
#endif
    item.paint(&imgPainter,nullptr,nullptr);
    imgPainter.end();


    doc.addResource(QTextDocument::ImageResource,QUrl("barcode_img"),barcodeImg);



    bool linePrinter=AppSettings::instance()->receiptLinePrinter();


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

    if(!linePrinter){

    stream.writeStartElement("th");
    stream.writeAttribute("width","32%");
    stream.writeAttribute("style","vertical-align: middle;");
    stream.writeStartElement("img");
    stream.writeAttribute("width","100");
    stream.writeAttribute("height","100");
    stream.writeAttribute("src", "qr_code");
    stream.writeEndElement(); //img
    stream.writeEndElement(); //th
    }

    stream.writeStartElement("th");
    int logoWidth=linePrinter? 100 : 36;
    stream.writeAttribute("width",QString::number(logoWidth)+"%");

    stream.writeStartElement("img");
    int logoSize=linePrinter? 50 : 150;
    stream.writeAttribute("width",QString::number(logoSize));
    stream.writeAttribute("height",QString::number(logoSize));
    stream.writeAttribute("src", "logo_image");
    stream.writeEndElement(); //img
    stream.writeEndElement(); //th

    if(!linePrinter){
    stream.writeStartElement("th");
    stream.writeAttribute("width","32%");
    stream.writeAttribute("style","vertical-align: middle;");
    stream.writeStartElement("img");
    stream.writeAttribute("width","150");
    stream.writeAttribute("height","60");
    stream.writeAttribute("src", "barcode_img");
    stream.writeEndElement(); //img
    stream.writeEndElement(); //th
}

    stream.writeEndElement(); //tr

    stream.writeEndElement(); //table


    QList<QJsonObject> hNo{
        {{"label",translator.translate("receipt","No.")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",QString::number(orderId)},{"width","75%",},{"class","boxed"},{"tag","td"}}
    };

    QList<QJsonObject> hDeliveryId{
        {{"label",translator.translate("receipt","Delivery No.")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",externalDeliveryId},{"width","75%",},{"class","boxed"},{"tag","td"}}
    };

    QList<QJsonObject> hDate{
        {{"label",translator.translate("receipt","Date")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",dt.date().toString(Qt::ISODate)},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hName{
        {{"label",translator.translate("receipt","Name")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",customer},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };

    QList<QJsonObject> hAddress{
        {{"label",translator.translate("receipt","Address")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",address},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hPhone{
        {{"label",translator.translate("receipt","Phone")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",phone},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hNotes{
        {{"label",translator.translate("receipt","Notes")},{"width","25%"},{"class","boxed center-align"},{"tag","th"}},
        {{"label",note},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };

    if(rtl){
        std::reverse(hNo.begin(),hNo.end());
        std::reverse(hDeliveryId.begin(),hDeliveryId.end());
        std::reverse(hDate.begin(),hDate.end());
        std::reverse(hName.begin(),hName.end());
        std::reverse(hAddress.begin(),hAddress.end());
        std::reverse(hPhone.begin(),hPhone.end());
        std::reverse(hNotes.begin(),hNotes.end());

    }

    QList<QList<QJsonObject>> header{hNo,hDeliveryId,hDate,hName,hAddress,hPhone,hNotes};
    stream.writeStartElement("table");
    stream.writeAttribute("class","boxed center");

    stream.writeAttribute("style", "width: 100%;");
    stream.writeStartElement("tbody");
    stream.writeAttribute("class","boxed");


    for(int i=0; i<header.count(); i++){
        QList<QJsonObject> row=header.at(i);
        stream.writeStartElement("tr");
        stream.writeAttribute("class","boxed");

        for(int j=0; j<row.count(); j++){
            QJsonObject column=row.at(j);
            stream.writeStartElement(column["tag"].toString()); //th or td
            stream.writeAttribute("class",column["class"].toString());
            stream.writeAttribute("width",column["width"].toString());
            stream.writeCharacters(column["label"].toString());
            stream.writeEndElement(); //tag
        }

        stream.writeEndElement(); //tr
    }





    stream.writeEndElement(); //tbody
    stream.writeEndElement(); //table


    stream.writeStartElement(linePrinter? "h5" : "h3");
    stream.writeAttribute("align","center");
    stream.writeCharacters(translator.translate("receipt","Original Receipt"));
    stream.writeEndElement(); //h2



    QList<QJsonObject> rtable{
        QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")},{"width","40%"}},
        QJsonObject{{"key","unitPrice"},{"label",translator.translate("receipt","Price")},{"width","20%"}},
        QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")},{"width","15%"}},
        //                QJsonObject{{"key","discount"},{"label",translator.translate("receipt","Disc.")},{"width","15%"}},
        //                QJsonObject{{"key","subtotal"},{"label",translator.translate("receipt","Subtotal")},{"width","20%"}},
        QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")},{"width","25%"}},
    };

    if(rtl){
        std::reverse(rtable.begin(),rtable.end());
    }


    stream.writeStartElement("table");
    stream.writeAttribute("style", "width: 100%;");
    stream.writeAttribute("class", "newItems");

    stream.writeStartElement("thead");
    stream.writeStartElement("tr");
    for(int i=0; i<rtable.count(); i++){
        QJsonObject column=rtable.at(i);
        stream.writeStartElement("th");
        stream.writeAttribute("class","newItems");
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
        //QString discount=QString::number(item["discount"].toDouble())+"%";
        QString subtotal=Currency::formatString(item["subtotal"].toDouble());
        QString total=Currency::formatString(item["total"].toDouble());

        QJsonObject tableRow{{"description",description},
                             {"unitPrice",unitPrice},
                             {"qty",qty},
                             //{"discount",discount},
                             {"subtotal",subtotal},{"total",total}};

        for(int i=0;i<rtable.count(); i++){
            QJsonObject column=rtable.at(i);
            stream.writeStartElement("td");
            if(column["key"].toString()=="qty"){
                if(tableRow[column["key"].toString()].toString().toInt()>1){
                    stream.writeStartElement("b");
                    stream.writeCharacters(tableRow[column["key"].toString()].toString());
                    stream.writeEndElement();

                }
                else{
                    stream.writeCharacters(tableRow[column["key"].toString()].toString());
                }
            }else{
                stream.writeCharacters(tableRow[column["key"].toString()].toString());

            }



            stream.writeEndElement();

        }
        stream.writeEndElement(); //tr

    }

    //receipt totals


    stream.writeEndElement(); //tbody
    stream.writeEndElement(); //table


    stream.writeEmptyElement("br");
    stream.writeEmptyElement("br");

    QList<QJsonObject> totals{
        {{"label",translator.translate("receipt","Total")},{"width","75%"}},
        {{"label",Currency::formatString(total)},{"width","75%"}}
    };

    QList<QJsonObject> totalsWidthDelivery{
        {{"label",translator.translate("receipt","Total + Delivery")},{"width","75%"}},
        {{"label",Currency::formatString(totalWithDelivery)},{"width","75%"}}
    };

    if(rtl){
        std::reverse(totals.begin(),totals.end());
        std::reverse(totalsWidthDelivery.begin(),totalsWidthDelivery.end());

    }

    stream.writeStartElement("table");
    stream.writeAttribute("width","100%");
    stream.writeStartElement("tr");
    for(int i=0;i<totals.count(); i++){
        QJsonObject item=totals.at(i);
        stream.writeStartElement("th");
        stream.writeAttribute("class","left receipt");
        if(item.contains("width")){
            stream.writeAttribute("width",item["width"].toString());
        }
        stream.writeCharacters(item["label"].toString());
        stream.writeEndElement(); //th
    }
    stream.writeEndElement(); //tr

    stream.writeStartElement("tr");

    for(int i=0;i<totalsWidthDelivery.count(); i++){
        QJsonObject item=totalsWidthDelivery.at(i);
        stream.writeStartElement("th");
        stream.writeAttribute("class","left receipt");
        if(item.contains("width")){
            stream.writeAttribute("width",item["width"].toString());
        }
        stream.writeCharacters(item["label"].toString());
        stream.writeEndElement(); //th
    }

    stream.writeEndElement(); //tr

    stream.writeEndElement(); //table


    stream.writeStartElement("section");
    stream.writeEmptyElement("br");
    stream.writeEndElement(); //section

    stream.writeStartElement("footer");
    if(linePrinter){
        stream.writeAttribute("style","text-align:center; font-size: small; font-weight: bold;");

    }else{
        stream.writeAttribute("style","text-align:center; font-size: large; font-weight: bold;");

    }
    // stream.writeAttribute("style","text-align:center; font-size: large; font-weight: bold;");


    stream.writeStartElement("p");
         stream.writeAttribute("class","receipt");
    stream.writeCharacters(AppSettings::instance()->receiptBottomNote());
    stream.writeEndElement(); //p
    stream.writeStartElement("p");
    stream.writeAttribute("dir","ltr");

         stream.writeAttribute("class","receipt");
    stream.writeCharacters(AppSettings::instance()->receiptPhoneNumber());
    stream.writeEndElement(); //p

    stream.writeEndElement(); //footer

    stream.writeEndElement(); //body
    stream.writeEndElement(); //html
    stream.writeEndDocument(); //doc


    QPageSize pageSize=QPageSize(AppSettings::pageSizeFromString(AppSettings::instance()->receiptPaperSize()));
//    pageSize=pageSize*2;

    doc.setPageSize(pageSize.sizePoints());



    doc.setHtml(text);


#ifndef Q_OS_IOS

    QPrinter pdfPrinter(QPrinter::HighResolution);
    pdfPrinter.setOutputFormat(QPrinter::OutputFormat::PdfFormat);
    pdfPrinter.setPageMargins(QMarginsF(0,0,0,0)); // is it right?
    QString random=QString::number(QRandomGenerator::global()->generate());
    pdfPrinter.setOutputFileName(QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0)+QString("/%1.pdf").arg(random));
    qDebug()<<"path: " <<pdfPrinter.outputFileName();
    doc.print(&pdfPrinter);

    if(print){
        QPrinter printer;
        printer.setPrinterName(AppSettings::instance()->receiptPrinter());

        printer.setPageMargins(QMarginsF(0,0,0,0)); // is it right?

        printer.setCopyCount(AppSettings::instance()->receiptCopies());
        printer.setPageSize(pageSize);
        doc.print(&printer);
    }



    return pdfPrinter.outputFileName();

#else
    return QString();

#endif
}


QString ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":993,"list_price":19087.5,"name":"312 - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return createNew(doc.object());

}



