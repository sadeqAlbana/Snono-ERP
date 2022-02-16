#include "saleschartmodel.h"
#include <QDateTime>
SalesChartModel::SalesChartModel(QObject *parent)
    : JsonModel(QJsonArray(),ColumnList{Column{"x","X"},Column{"y","Y"}},parent)
{


}
