#include "stockreportmodel.h"
#include <QTextDocument>
#include <QXmlStreamWriter>
#include <QStringList>
#include <QPrinter>
#include <QPrinterInfo>
#include <QFile>
#include <QBuffer>
#include <QStandardPaths>
#include <QTextStream>
StockReportModel::StockReportModel(QObject *parent) :
    AppNetworkedJsonModel("/reports/stock",{{"id",tr("ID")},
                                                  {"name",tr("Product"),QString(),false,"link",
                                                   QVariantMap{{"link","qrc:/PosFe/qml/pages/products/ProductForm.qml"},
                                                          {"linkKey","id"}}},
                                                   {"stock",tr("Stock")},

                                               },parent,false)
{

}

void StockReportModel::print()
{
    QString text;
    QXmlStreamWriter stream(&text);
    QDateTime dt=QDateTime::currentDateTime();
    QStringList headers{"Item","Stock","Item","Stock","Item","Stock","Item","Stock","Item","Stock"};
    stream.setAutoFormatting(true);
    stream.writeStartDocument();
    stream.writeStartElement("html");

    stream.writeTextElement("style","table, th,td,tr,h2 {border:1px solid black; text-align: center; width:100%; border-collapse: collapse;}");

    stream.writeTextElement("h2",QString("Stock Report for %1").arg(dt.toString()));


    stream.writeStartElement("table");
    stream.writeAttribute("style", "width:100%;");
    stream.writeStartElement("tr");
    for(auto header: headers){
        stream.writeTextElement("th",header);
    }
    stream.writeEndElement();//tr

    for(int i=0; i<rowCount(); i+=5){
        stream.writeStartElement("tr");
        if(i%2==0)
            stream.writeAttribute("style","background-color:#F0F0F0;");

        for(int j=i; j<i+5; j++){
        QJsonObject record=this->recordAt(j);
        stream.writeTextElement("td",record["name"].toString());
        stream.writeTextElement("td",QString::number(record["stock"].toDouble()));
        }



        stream.writeEndElement();//tr
    }



    stream.writeEndElement(); //table
    stream.writeEndElement(); //html
    stream.writeEndDocument();

    QTextDocument doc;
    doc.setHtml(text);

#ifndef Q_OS_IOS
    QPrinter printer(QPrinterInfo::defaultPrinter());
    printer.setPageSize(QPageSize::A4);
    doc.print(&printer);

    printCSV();
#endif

}

void StockReportModel::printCSV()
{
    QFile file(QStandardPaths::standardLocations(QStandardPaths::DesktopLocation).value(0)+"/report.csv");
    file.open(QIODevice::WriteOnly | QFile::Truncate);
    QTextStream out(&file);

    out << "item" << "," <<"qty" << Qt::endl;

    for(int i=0; i<rowCount(); i++){
        QJsonObject record=this->recordAt(i);

        out << record["name"].toString() << "," <<QString::number(record["stock"].toDouble()) << Qt::endl;

        }


    file.close();

}
