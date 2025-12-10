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
#include <QAbstractTextDocumentLayout>
#include "api.h"

/*

A note about QPrinter,
there are three printing modes on the constructor, they all work to set the printerResulotion property

1- QPrinter::ScreenResolution:  as it says, This is the default value. ScreenResolution will produce a lower quality output than HighResolution and should only be used for drafts.
2- QPrinter::PrinterResolution: This value is deprecated. It is equivalent to ScreenResolution on Unix and HighResolution on Windows and Mac
3- QPrinter::HighResolution: On Windows, sets the printer resolution to that defined for the printer in use. For PDF printing, sets the resolution of the PDF driver to 1200 dpi.

here is the behaviour on a 1920x1080 linux machine
QPrinter; => 96
QPrinter(QPrinter::ScreenResolution); => 96
QPrinter(QPrinter::PrinterResolution); => 72 (actual is 203)
QPrinter(QPrinter::HighResolution); => 1200

so as it says, one should avoid using screen and printer resolution parameters,
however, this method was tested and proved to be broken on linux as it sets it to 1200dpi even for real printers.
all these parameters work on QPrinter::setResolution() so you can set it manually with the below method and get it over with.
I have found a solution which is to use QPrinterInfo and get the supportedResolutions list and use one of the supported resolutions.supportedResolutions


 */


ReceiptGenerator::ReceiptGenerator(QObject *parent) : QObject(parent)
{

}




QString ReceiptGenerator::createDeliveryReceipt(QJsonObject receiptData, const bool print)
{
    // bool linePrinter=AppSettings::instance()->receiptLinePrinter();
    bool linePrinter=false;

    QJsonArray items=receiptData["order_items"].toArray();

    QImage logo(AppSettings::storagePath()+"/assets/receipt_logo.png");



    int orderId=receiptData["id"].toInt();
    QString reference=QString("No. %1").arg(orderId);


    double taxAmount=receiptData["tax_amount"].toDouble();

    QString customer;
    QString phone;
    QString addressStr;

    bool useLocalCustomerInfo=receiptData["order_type"]=="pos";
    qDebug()<<"receipt data:" << receiptData;
    QJsonObject shipment=receiptData["shipment"].toObject();
    QJsonObject carrier=shipment["carrier"].toObject();
    QString shipmentId=QString::number(shipment["id"].toInt());
    QString thirdPartyShipmentId=shipment["third_party_carrier_shipment_id"].toString();
    QString carrierName= carrier["name"].toString();
    if(carrier["id"].toInt()!=1){
        carrierName.append(QString(" - %1").arg(thirdPartyShipmentId));
    }
    if(!useLocalCustomerInfo){
        QJsonObject addressObject=shipment["dst_address"].toObject();
        customer=addressObject["first_name"].toString();
        phone=addressObject["phone"].toString();
        QString province=addressObject["province"].toString();
        QString district=addressObject["district"].toString();
        QString addressDetails=addressObject["details"].toString();
        addressStr=QString("%1 - %2").arg(province).arg(district);
        if(addressDetails.size()){
            addressStr.append(QString(" - %1").arg(addressDetails));
        }
    }else{
        QString customer=receiptData["customers"].toObject()["name"].toString();
        phone=receiptData["customers"].toObject()["phone"].toString();
        addressStr=receiptData["customers"].toObject()["address"].toString();

    }

    // QString address=receiptData["customers"].toObject()["address"].toString();
    double total=receiptData["total"].toDouble();
    QString date=receiptData["date"].toString();
    QDateTime dt=QDateTime::fromString(date,Qt::ISODate);
    QString note=receiptData["note"].toString();



    double totalWithDelivery=total;
    double deliveryFee=0;
    bool haveDiscount=false;

    for(int i=0; i<items.size(); i++){
        QJsonObject item=items.at(i).toObject();

        if(item["discount"].toInt()>0){
            haveDiscount=true;
        }

    }
    if(receiptData.contains("external_delivery")){
        deliveryFee=receiptData["external_delivery"].toDouble();
    }else{
        deliveryFee=shipment["fee"].toDouble();
    }


    totalWithDelivery=total+deliveryFee;

    //painter.drawPixmap(QRect(20,20,180,180),qrPixmap);

    const QString baseName = "pos-fe_" + QLocale("ar-IQ").name();
    qDebug()<<"Base name: " << baseName;
    QTranslator translator;
    qDebug()<<"translator load: "<< translator.load(":/i18n/" + baseName);

    bool rtl=true;




    QTextDocument doc;
    //consider using QTextOption to change text direction !

    QFile file(":/receipt/style.css");
    qDebug()<<"file open: " <<file.open(QIODevice::ReadOnly);
    QString css=file.readAll();
    file.close();
    QString bodyFontSize=linePrinter? "6px" : "10px";
    QString footerFontSize=linePrinter? "8px" : "11px";

    QString bodyMargin = linePrinter? "10" : 0;
    css.replace("{{body_font_size}}",bodyFontSize);
    css.replace("{{footer_font_size}}",footerFontSize);

    css.replace("{{body_margin}}",bodyMargin);

    //doc.setDefaultStyleSheet(css);

    doc.addResource(QTextDocument::ImageResource,QUrl("logo_image"),logo);

    QString qrText=QString(R"(BEGIN:VCARD
VERSION:3.0
FN:%1
TEL;TYPE=CELL:%2
END:VCARD)").arg(customer).arg(phone);

    qrcodegen::QrCode qr0 = qrcodegen::QrCode::encodeText(qrText.toStdString().c_str(), qrcodegen::QrCode::Ecc::MEDIUM);
    std::string svgString = QrCode::toSvgString(qr0, 0);  // See QrCodeGeneratorDemo



    QString addressQrData=AppSettings::instance()->addressQr();

    if(!addressStr.isEmpty()){
        qrcodegen::QrCode qr0 = qrcodegen::QrCode::encodeText(addressQrData.toStdString().c_str(), qrcodegen::QrCode::Ecc::MEDIUM);
        std::string svgString = QrCode::toSvgString(qr0, 0);  // See QrCodeGeneratorDemo
        QSvgRenderer svg(QByteArray::fromStdString(svgString));
        QPixmap qrPixmap(1000,1000);
        QPainter qrPainter(&qrPixmap);
        svg.render(&qrPainter);
        qrPainter.end();
        doc.addResource(QTextDocument::ImageResource,QUrl("address_qr"),qrPixmap);

    }

    QSvgRenderer svg(QByteArray::fromStdString(svgString));
    QPixmap qrPixmap(1000,1000);
    QPainter qrPainter(&qrPixmap);
    svg.render(&qrPainter);
    qrPainter.end();

    doc.addResource(QTextDocument::ImageResource,QUrl("qr_code"),qrPixmap);

    QImage barcodeImg(240,120,QImage::Format_RGB32);
    barcodeImg.fill(Qt::white);
    QPainter imgPainter(&barcodeImg);
    Code128Item item;
#ifndef Q_OS_IOS
    item.setPos(0,0);
#endif
    item.setWidth( barcodeImg.width() );
    item.setHeight( barcodeImg.height() );
    item.setText(shipmentId);

#ifndef Q_OS_IOS
    item.update();
#endif
    item.paint(&imgPainter,nullptr,nullptr);
    imgPainter.end();


    doc.addResource(QTextDocument::ImageResource,QUrl("barcode_img"),barcodeImg);





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
        stream.writeAttribute("width","55");
        stream.writeAttribute("height","55");
        stream.writeAttribute("src", "qr_code");
        stream.writeEndElement(); //img
        stream.writeEndElement(); //th
    }

    stream.writeStartElement("th");
    int logoWidth=linePrinter? 100 : 36;
    stream.writeAttribute("width",QString::number(logoWidth)+"%");

    stream.writeStartElement("img");
    int logoSize=linePrinter? 40 : 45;
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
        stream.writeAttribute("width","96");
        stream.writeAttribute("height","48");
        stream.writeAttribute("src", "barcode_img");
        stream.writeEndElement(); //img
        stream.writeEndElement(); //th
    }

    stream.writeEndElement(); //tr

    stream.writeEndElement(); //table


    // QList<QJsonObject> hNo{
    //     {{"label",translator.translate("receipt","No.")},{"width","25%"},{"class","boxed"},{"tag","th"}},
    //     {{"label",QString::number(orderId)},{"width","75%",},{"class","boxed"},{"tag","td"}}
    // };

    QList<QJsonObject> hCarrier{
        {{"label",translator.translate("receipt","Carrier")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",QString("%1 - %2").arg(carrierName,shipmentId)},{"width","75%",},{"class","boxed"},{"tag","td"}}
    };

    // QList<QJsonObject> hDeliveryId{
    //     {{"label",translator.translate("receipt","Shipment ID")},{"width","25%"},{"class","boxed"},{"tag","th"}},
    //     {{"label",shipmentId},{"width","75%",},{"class","boxed"},{"tag","td"}}
    // };

    QList<QJsonObject> hDate{
        {{"label",translator.translate("receipt","Date")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",dt.date().toString(Qt::ISODate)},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hName{
        {{"label",translator.translate("receipt","Name")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",customer},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };

    QList<QJsonObject> hAddress{
        {{"label",translator.translate("receipt","Address")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",addressStr},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hPhone{
        {{"label",translator.translate("receipt","Phone")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",phone},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hNotes{
        {{"label",translator.translate("receipt","Notes")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",note},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };

    if(rtl){
        // std::reverse(hNo.begin(),hNo.end());
        std::reverse(hCarrier.begin(),hCarrier.end());
        // std::reverse(hDeliveryId.begin(),hDeliveryId.end());
        std::reverse(hDate.begin(),hDate.end());
        std::reverse(hName.begin(),hName.end());
        std::reverse(hAddress.begin(),hAddress.end());
        std::reverse(hPhone.begin(),hPhone.end());
        std::reverse(hNotes.begin(),hNotes.end());

    }

    QList<QList<QJsonObject>> header{hCarrier,hDate,hName,hAddress,hPhone,hNotes};
    stream.writeStartElement("table");
    stream.writeAttribute("class","boxed");

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


    // stream.writeStartElement(linePrinter? "h6" : "h3");
    // stream.writeAttribute("align","center");
    // stream.writeCharacters(translator.translate("receipt","Original Receipt"));
    // stream.writeEndElement(); //h2



    QList<QJsonObject> rtable;

    if(haveDiscount){
        rtable= {
                  QJsonObject{{"key","row"},{"label",""},{"width","8%"}},
                  QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")}},
                  QJsonObject{{"key","unitPrice"},{"label",translator.translate("receipt","Price")}},
                  QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")}},

                  QJsonObject{{"key","discount"},{"label",translator.translate("receipt","Disc.")}},
                  //                QJsonObject{{"key","subtotal"},{"label",translator.translate("receipt","Subtotal")},{"width","20%"}},
                  QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")}},
                  };
    }else{
        rtable=  {
                  QJsonObject{{"key","row"},{"label",""},{"width","8%"}},
                  QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")}},
                  QJsonObject{{"key","unitPrice"},{"label",translator.translate("receipt","Price")}},
                  QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")}},

                  //                QJsonObject{{"key","discount"},{"label",translator.translate("receipt","Disc.")},{"width","15%"}},
                  //                QJsonObject{{"key","subtotal"},{"label",translator.translate("receipt","Subtotal")},{"width","20%"}},
                  QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")}},
                  };
    }

    if(rtl){
        std::reverse(rtable.begin(),rtable.end());
    }


    stream.writeStartElement("table");
    stream.writeAttribute("width","100%");
    stream.writeAttribute("style", "width: 100%; text-align: center;");
    stream.writeAttribute("class", "items_content");

    stream.writeStartElement("thead");
    stream.writeStartElement("tr");

    for(int i=0; i<rtable.count(); i++){
        QJsonObject column=rtable.at(i);
        stream.writeStartElement("th");
        stream.writeAttribute("class","items_content");

        if(column.contains("width")){
            stream.writeAttribute("width",column["width"].toString());
        }
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
        QString unitPrice=Currency::formatNumber(item["unit_price"].toDouble());
        QString qty=QString::number(item["qty"].toDouble());
        QString discount=QString::number(item["discount"].toDouble())+"%";
        // QString subtotal=Currency::formatNumber(item["subtotal"].toDouble());
        QString total=Currency::formatNumber(item["total"].toDouble());

        QJsonObject tableRow;

        if(haveDiscount){
            tableRow={{"row",QString::number(i+1)},
                        {"description",description},
                        {"unitPrice",unitPrice},
                        {"qty",qty},
                        {"discount",discount},
                        // {"subtotal",subtotal},
                        {"total",total}};

        }else{
            tableRow={{"row",QString::number(i+1)},
                        {"description",description},
                        {"unitPrice",unitPrice},
                        {"qty",qty},
                        //{"discount",discount},
                        // {"subtotal",subtotal},
                        {"total",total}};
        }
        for(int i=0;i<rtable.count(); i++){
            QJsonObject column=rtable.at(i);
            stream.writeStartElement("td");
            stream.writeAttribute("class","items_content");

            if(column["key"].toString()=="qty"){
                if(tableRow[column["key"].toString()].toString().toInt()>1){// bold if larger than 1
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


    // stream.writeEmptyElement("br");
    // stream.writeEmptyElement("br");

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
        stream.writeAttribute("class","left_align receipt");
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
        stream.writeAttribute("class","left_align receipt");
        if(item.contains("width")){
            stream.writeAttribute("width",item["width"].toString());
        }
        stream.writeCharacters(item["label"].toString());
        stream.writeEndElement(); //th
    }

    stream.writeEndElement(); //tr

    stream.writeEndElement(); //table


    // stream.writeStartElement("section");
    // stream.writeEmptyElement("br");
    // stream.writeEndElement(); //section

    stream.writeStartElement("footer");
    // if(linePrinter){
    //     stream.writeAttribute("style","text-align:center; font-weight: bold;");

    // }else{
    //     stream.writeAttribute("style","text-align:center;font-weight: bold;");

    // }
    // stream.writeAttribute("style","text-align:center; font-size: large; font-weight: bold;");


    stream.writeStartElement("p");
    stream.writeAttribute("class","receipt bottom-note");
    stream.writeCharacters(AppSettings::instance()->receiptBottomNote());
    stream.writeEndElement(); //p
    stream.writeStartElement("p");
    stream.writeAttribute("dir","ltr");

    stream.writeAttribute("class","receipt bottom-note");
    stream.writeCharacters(AppSettings::instance()->receiptPhoneNumber());
    stream.writeEndElement(); //p

    if(!addressQrData.isEmpty()){
        stream.writeStartElement("table");
        stream.writeAttribute("width","100%");
        stream.writeStartElement("tr");
        stream.writeStartElement("th");
        stream.writeAttribute("width","100%");
        stream.writeAttribute("style","vertical-align: middle;");
        stream.writeStartElement("img");
        stream.writeAttribute("width","45");
        stream.writeAttribute("height","45");
        stream.writeAttribute("src", "address_qr");
        stream.writeEndElement(); //img
        stream.writeEndElement(); //th
        stream.writeEndElement(); //tr

        stream.writeStartElement("tr");
        stream.writeStartElement("th");
        stream.writeAttribute("width","100%");
        stream.writeAttribute("class","receipt bottom-note");

        stream.writeCharacters(translator.translate("receipt","Scan Me"));
        stream.writeEndElement(); //th
        stream.writeEndElement(); //tr

        stream.writeStartElement("tr");
        stream.writeStartElement("th");
        stream.writeAttribute("width","100%");
        stream.writeAttribute("class","receipt bottom-note");

        stream.writeCharacters(AppSettings::instance()->receiptAddressLine());
        stream.writeEndElement(); //th
        stream.writeEndElement(); //tr

        stream.writeEndElement(); //table
    }





    stream.writeEndElement(); //footer

    stream.writeEndElement(); //body
    stream.writeEndElement(); //html
    stream.writeEndDocument(); //doc

    QPageSize pageSize;
    QPrinter printer;
    printer.setPrinterName(AppSettings::instance()->receiptPrinter());
    QString ps=AppSettings::instance()->receiptPaperSize();
    if(ps=="Default"){
        pageSize=printer.pageLayout().pageSize();


    }else{
        pageSize=QPageSize(AppSettings::pageSizeFromString(ps));
        doc.setPageSize(pageSize.sizePoints());
    }

    qDebug()<<"page size: " <<pageSize;




    doc.setHtml(text);
    QString random=QString::number(QRandomGenerator::global()->generate());
    QString filePathAndNameNoExtension=QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0)+QString("/%1").arg(random);
//below needs to be corrected
//qt print support is available on all but ios
//qt pdf is not available on ios and android
#ifndef Q_OS_IOS

    QPrinter pdfPrinter(QPrinter::HighResolution);
    pdfPrinter.setOutputFormat(QPrinter::OutputFormat::PdfFormat);
    pdfPrinter.setPageMargins(QMarginsF(5,5,5,5)); // is it right?
    pdfPrinter.setPageSize(pageSize);


    pdfPrinter.setOutputFileName(filePathAndNameNoExtension+".pdf");
    qDebug()<<"path: " <<pdfPrinter.outputFileName();
    doc.print(&pdfPrinter);

    if(print){


        printer.setPageMargins(QMarginsF(5,5,5,5)); // is it right?

        int copyCount = thirdPartyShipmentId.isEmpty()? AppSettings::instance()->receiptCopies() : AppSettings::instance()->receiptCopiesWithExternalDelivery();
        printer.setCopyCount(copyCount);
        printer.setPageSize(pageSize);
        doc.print(&printer);
    }
#endif

#ifdef QT_NO_PDF
    QImage image=renderToImage(doc,3);
    qDebug()<<"image: " << filePathAndNameNoExtension+".png";
    qDebug()<<"image save: " <<image.save(filePathAndNameNoExtension+".png");
#endif

    return filePathAndNameNoExtension;
}

QString ReceiptGenerator::createCashierReceipt(QJsonObject receiptData, const bool print)
{
    bool linePrinter=AppSettings::instance()->receiptLinePrinter();

    QJsonArray items=receiptData["order_items"].toArray();

    QImage logo(AppSettings::storagePath()+"/assets/receipt_logo.png");

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
    double deliveryFee=0;
    bool haveDiscount=false;

    for(int i=0; i<items.size(); i++){
        QJsonObject item=items.at(i).toObject();

        if(item["discount"].toInt()>0){
            haveDiscount=true;
        }

    }




    //painter.drawPixmap(QRect(20,20,180,180),qrPixmap);

    const QString baseName = "pos-fe_" + QLocale("ar-IQ").name();
    qDebug()<<"Base name: " << baseName;
    QTranslator translator;
    qDebug()<<"translator load: "<< translator.load(":/i18n/" + baseName);

    bool rtl=true;




    QTextDocument doc;
    //consider using QTextOption to change text direction !
    // doc.setDefaultFont(QFont("Courier New", 10));
    QFile file(":/receipt/PosStyle.css");
    qDebug()<<"file open: " <<file.open(QIODevice::ReadOnly);
    QString css=file.readAll();
    file.close();
    QString bodyFontSize=linePrinter? "8px" : "12px";
    QString bodyMargin = linePrinter? "0" : 0;
    css.replace("{{body_font_size}}",bodyFontSize);
    css.replace("{{body_margin}}",bodyMargin);

    //doc.setDefaultStyleSheet(css);
    doc.addResource(QTextDocument::ImageResource,QUrl("logo_image"),logo);
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
    stream.writeAttribute("width","100%");

    stream.writeStartElement("img");
    int logoSize=50;
    stream.writeAttribute("width",QString::number(logoSize));
    stream.writeAttribute("height",QString::number(logoSize));
    stream.writeAttribute("src", "logo_image");
    stream.writeEndElement(); //img
    stream.writeEndElement(); //th

    stream.writeEndElement(); //tr

    stream.writeEndElement(); //table


    QList<QJsonObject> hNo{
        {{"label",translator.translate("receipt","No.")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",QString::number(orderId)},{"width","75%",},{"class","boxed"},{"tag","td"}}
    };



    QList<QJsonObject> hDate{
        {{"label",translator.translate("receipt","Date")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",dt.toString("hh:mm yyyy-MM-dd")},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };


    QList<QJsonObject> hName{
        {{"label",translator.translate("receipt","Name")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",customer},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };







    QList<QJsonObject> hNotes{
        {{"label",translator.translate("receipt","Notes")},{"width","25%"},{"class","boxed"},{"tag","th"}},
        {{"label",note},{"width","75%"},{"class","boxed"},{"tag","td"}}
    };

    if(rtl){
        std::reverse(hNo.begin(),hNo.end());
        std::reverse(hDate.begin(),hDate.end());
        std::reverse(hName.begin(),hName.end());
        std::reverse(hNotes.begin(),hNotes.end());

    }

    QList<QList<QJsonObject>> header{hNo,hDate,hName,hNotes};
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


    stream.writeStartElement(linePrinter? "h6" : "h3");
    stream.writeAttribute("align","center");
    stream.writeCharacters(translator.translate("receipt","Original Receipt"));
    stream.writeEndElement(); //h2



    QList<QJsonObject> rtable;

    if(haveDiscount){
        rtable= {
                  QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")}},
                  QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")}},

                  QJsonObject{{"key","discount"},{"label",translator.translate("receipt","Disc.")}},
                  //                QJsonObject{{"key","subtotal"},{"label",translator.translate("receipt","Subtotal")},{"width","20%"}},
                  QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")}},
                  };
    }else{
        rtable=  {
                  QJsonObject{{"key","qty"},{"label",translator.translate("receipt","Qty")}},
                  QJsonObject{{"key","description"},{"label",translator.translate("receipt","Item")}},
                  QJsonObject{{"key","total"},{"label",translator.translate("receipt","Total")}},
                  };
    }

    if(rtl){
        std::reverse(rtable.begin(),rtable.end());
    }


    stream.writeStartElement("table");
    stream.writeAttribute("width","100%");
    stream.writeAttribute("style", "width: 100%;");
    stream.writeAttribute("class", "items_content");

    stream.writeStartElement("thead");
    stream.writeStartElement("tr");
    for(int i=0; i<rtable.count(); i++){
        QJsonObject column=rtable.at(i);
        stream.writeStartElement("th");
        stream.writeAttribute("class","items_content");
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

        QJsonObject tableRow;

        if(haveDiscount){
            tableRow={
                        {"qty",qty},
                        {"description",description},
                        {"discount",discount},
                        {"total",total}};

        }else{
            tableRow={
                        {"qty",qty},
                        {"description",description},
                        {"total",total}};
        }
        for(int i=0;i<rtable.count(); i++){
            QJsonObject column=rtable.at(i);
            stream.writeStartElement("td");
            stream.writeAttribute("class","items_content");

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



    if(rtl){
        std::reverse(totals.begin(),totals.end());

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
    stream.writeCharacters(AppSettings::instance()->posReceiptBottomNote());
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


    //QPageSize pageSize=QPageSize(AppSettings::pageSizeFromString(AppSettings::instance()->receiptPaperSize()));
    //    pageSize=pageSize*2;


    QString random=QString::number(QRandomGenerator::global()->generate());
    QString filePathAndNameNoExtension=QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0)+QString("/%1").arg(random);

#ifndef Q_OS_IOS

    QPrinter printer;
    printer.setPrinterName(AppSettings::instance()->linePrinter());

    if(QPrinterInfo(printer).supportedResolutions().size()){ //avoids crash
        printer.setResolution(QPrinterInfo(printer).supportedResolutions().first()); //this is the game changer

    }
    printer.setPageSize(QPageSize(QSizeF(80, 297), QPageSize::Millimeter));
    // printer.setPageMargins(QMarginsF(0,0,0,0),QPageLayout::Millimeter);
    // printer.setFullPage(true);  // Use full page for printing

    doc.setPageSize(printer.pageLayout().pageSize().sizePoints());



    doc.setHtml(text);
    //POS-80-Series

    QPrinter pdfPrinter;
    pdfPrinter.setOutputFormat(QPrinter::OutputFormat::PdfFormat);
    pdfPrinter.setPrinterName(AppSettings::instance()->linePrinter());


    if(QPrinterInfo(printer).supportedResolutions().size()){ //avoids crash
    pdfPrinter.setResolution(QPrinterInfo(printer).supportedResolutions().first()); //this is the game changer    printer.setPageSize(QPageSize(QSizeF(80, 297), QPageSize::Millimeter));
    }
    pdfPrinter.setPageSize(QPageSize(QSizeF(80, 297), QPageSize::Millimeter));
    // pdfPrinter.setPageMargins(QMarginsF(0,0,0,0),QPageLayout::Millimeter);
    // pdfPrinter.setFullPage(true);  // Use full page for printing

    // auto layout=printer.pageLayout();
    // layout.setOrientation(QPageLayout::Portrait);
    // printer.setPageLayout(layout);
    // doc.setPageSize(QSizeF(printer.pageRect(QPrinter::Millimeter).width(), printer.pageRect(QPrinter::Millimeter).height()));

    pdfPrinter.setOutputFileName(QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0)+QString("/%1.pdf").arg(random));
    qDebug()<<"path: " <<pdfPrinter.outputFileName();
    doc.print(&pdfPrinter);

    if(print){
        doc.print(&printer);
        // painter.end();
    }

    return pdfPrinter.outputFileName();

#else
    return QString();

#endif
}

QString ReceiptGenerator::generateSheinOrderManifestLabel(const QString &orderNo, const QVariantList &trackingsNumbers)
{
    return generateOrderReferenceAndTrackings(orderNo,Json::stringListFromVariantList(trackingsNumbers));
}

QString ReceiptGenerator::generateOrderReferenceAndTrackings(const QString &orderNo, const QStringList &trackingNumbers)
{
    QPrinter printer(QPrinter::HighResolution);
    printer.setCopyCount(1);
    printer.setPrinterName(AppSettings::instance()->labelPrinter());
    float labelWidth=AppSettings::instance()->labelPrinterLabelWidth();
    float labelHeight=AppSettings::instance()->labelPrinterLabelHeight();
    QPageSize::Unit unit=static_cast<QPageSize::Unit>(AppSettings::instance()->labelPrinterLabelSizeUnit());

    printer.setPageSize(QPageSize(QSizeF(labelWidth, labelHeight), unit));

    printer.setFullPage(true);

    QPainter painter(&printer);

    // Set font size and style
    QFont font;
    font.setPointSize(7);
    painter.setFont(font);
    font.setWeight(QFont::DemiBold);
    // Draw text on the label
    painter.setFont(font);



    painter.drawText(25,30,orderNo);
    font.setWeight(QFont::Normal);
    font.setPointSize(7);
    painter.setFont(font);

    int y=70;
    for(const  QString &str : trackingNumbers){
        painter.drawText(25,y,str);
        y+=40;

    }
    // painter.drawText(rect, Qt::AlignCenter, "Sample Label Text");

    painter.end();

    return QString();

}

QString ReceiptGenerator::generateLabel(const QString &barcode, const QString &name, const QString &price, const QString &sku, const QUrl &imageUrl, const int copies)
{

    QImage barcodeImg(205,75,QImage::Format_RGB32);
    barcodeImg.fill(Qt::white);
    QPainter imgPainter(&barcodeImg);
    Code128Item item;
    item.setHighDPI(true);
#ifndef Q_OS_IOS
    item.setPos(0,0);
#endif
    item.setWidth( barcodeImg.width() );
    item.setHeight( barcodeImg.height() );
    item.setText(barcode);

#ifndef Q_OS_IOS
    item.update();
#endif
    item.paint(&imgPainter,nullptr,nullptr);
    imgPainter.end();


    // doc.addResource(QTextDocument::ImageResource,QUrl("barcode_img"),barcodeImg);

    QPrinter printer(QPrinter::HighResolution);
    printer.setCopyCount(copies);
    printer.setPrinterName(AppSettings::instance()->labelPrinter());
    printer.setResolution(QPrinterInfo(printer).supportedResolutions().first()); //this is the game changer

    float labelWidth=AppSettings::instance()->labelPrinterLabelWidth();
    float labelHeight=AppSettings::instance()->labelPrinterLabelHeight();
    QPageSize::Unit unit=static_cast<QPageSize::Unit>(AppSettings::instance()->labelPrinterLabelSizeUnit());
    printer.setPageSize(QPageSize(QSizeF(labelWidth, labelHeight), unit));

    printer.setFullPage(true);

    QPainter painter(&printer);

    // Set font size and style
    QFont font;
    font.setPointSize(7);
    painter.setFont(font);
    font.setWeight(QFont::DemiBold);
    // Draw text on the label
    QRect rect = painter.viewport();
    painter.setFont(font);



    painter.drawText(25,30,name);
    painter.drawImage(25,40,barcodeImg);


    font.setWeight(QFont::DemiBold);
    font.setPointSize(7);
    painter.setFont(font);
    if(!sku.isEmpty()){
        painter.drawText(25,170,tr("SKU: ")+ sku);

    }
    painter.drawText(25,195,tr("Price: ")+ price);


    // painter.drawText(rect, Qt::AlignCenter, "Sample Label Text");



    if(imageUrl.isValid()){
        QImage img=Api::instance()->cachedImage(imageUrl);
        qDebug()<<"got image: " << img.isNull();
        painter.drawImage(printer.width()-100,30,img.scaledToWidth(120));

    }

    painter.end();

    return QString();
}

QImage ReceiptGenerator::renderToImage(QTextDocument &doc, const int scaleFactor)
{
    QImage image((doc.pageSize().toSize()*scaleFactor), QImage::Format_ARGB32);
    image.fill(Qt::white);
    QPainter painter(&image);
    painter.scale(scaleFactor,scaleFactor);
    doc.drawContents(&painter,image.rect());

    return image;
}

QString ReceiptGenerator::sampleData()
{
    QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"Baghdad, Hay Alkhadraa","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"Sadeq","id":1,"last_name":"Albana","name":"Customer","phone":"07823815562","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":993,"list_price":19087.5,"name":"312 - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
    return createDeliveryReceipt(doc.object());

}



