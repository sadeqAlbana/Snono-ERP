#include "productsalesreportmodel.h"
#include "utils.h"
ProductSalesReportModel::ProductSalesReportModel(QObject *parent)
    : AppNetworkedJsonModel{"/reports/productSales",{
                            {"thumb",tr("Thumb"),QString(),false,"image"} ,
                            {"name",tr("Name")} ,
                            {"qty",tr("Quantity")} ,
                            {"total",tr("Total"),QString(),false,"currency"}
                            }
                            ,parent}
{

}

const QDate &ProductSalesReportModel::from() const
{
    return m_from;
}

void ProductSalesReportModel::setFrom(const QDate &newFrom)
{
    if (m_from == newFrom)
        return;
    m_from = newFrom;
    emit fromChanged();
}

const QDate &ProductSalesReportModel::to() const
{
    return m_to;
}

void ProductSalesReportModel::setTo(const QDate &newTo)
{
    if (m_to == newTo)
        return;
    m_to = newTo;
    emit toChanged();
}

bool ProductSalesReportModel::print()
{
    QJsonArray data=m_records;

    double totalOfTotal=0;
    double totalQty=0;

    for(QJsonValueRef ref : data){

        QJsonObject obj=ref.toObject();
        totalOfTotal+=obj["total"].toDouble();
        totalQty+=obj["qty"].toDouble();

        obj["total"]=Currency::formatString(obj["total"].toDouble());
        ref=obj;
    }

    QString range=QStringLiteral("All time");
    QString from;
    QString to;
    if(m_filter.contains("from")){
        from=m_filter.value("from").toString();
    }
    if(m_filter.contains("to")){
        to=m_filter.value("to").toString();
    }

    data << QJsonObject{{"name","total"},{"qty",totalQty},{"total",Currency::formatString(totalOfTotal)}};

    range=QString("%1 - %2").arg(from,to);
        return Json::printJson(QString("Sales Report for period %1").arg(range)
                           ,data,QList<QPair<QString,QString>>{{"Name","name"},{"Qty","qty"},{"Total",{"total"}}});
}
