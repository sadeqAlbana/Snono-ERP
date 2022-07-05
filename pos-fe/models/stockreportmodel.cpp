#include "stockreportmodel.h"
#include <QTextDocument>
#include <QXmlStreamWriter>
#include <QStringList>
#include <QPrinter>
#include <QPrinterInfo>
StockReportModel::StockReportModel(QObject *parent)
    : AppNetworkedJsonModel{"/reports/stock",ColumnList(),parent}
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

    stream.writeTextElement("style","table, th,td,tr,h2 {border:1px solid black; text-align: center; width:100%}");

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
        QJsonObject record=this->record(j);
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
    QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
    printer.setPageSize(QPageSize::A4);
    doc.print(&printer);

}
