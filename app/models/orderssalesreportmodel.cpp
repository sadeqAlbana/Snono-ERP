#include "orderssalesreportmodel.h"
#include "utils.h"
OrdersSalesReportModel::OrdersSalesReportModel(QObject *parent)
    : JsonModel{parent}
{}


bool OrdersSalesReportModel::print(QJsonArray data, const QString &from, const QString &to)
{
    if(data.isEmpty()){
        data=m_records;
    }
    int total=0;
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();



        total+=product["total"].toInt();

        product["total"]=Currency::formatString(product["total"].toInt());
        data.replace(i,product);
    }

    data.append(QJsonObject{{"reference","total"},
        // {"customer",""},
        // {"address",""},
        {"date",""},
        {"total",Currency::formatString(total)}

    });

    QString range=QStringLiteral("All time");

    range=QString("%1 - %2").arg(from,to);

    return Json::printJson(QString("Orders Report for period %1").arg(range),data,{{"reference","Reference"},
                                                                                 // {"customer","Customer"},
                                                                                 //                                            {"address","Address"},
                                                                                 {"date","Date"},
                                                                                 {"total","Total"}

                                                                             });

}
