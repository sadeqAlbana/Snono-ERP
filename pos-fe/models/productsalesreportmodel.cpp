#include "productsalesreportmodel.h"

ProductSalesReportModel::ProductSalesReportModel(QObject *parent)
    : AppNetworkedJsonModel{"/reports/productSales",{
                            Column{"name","Name"} ,
                            Column{"qty","Quantity"} ,

                            Column{"total","Total",QString(),"currency"}
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
