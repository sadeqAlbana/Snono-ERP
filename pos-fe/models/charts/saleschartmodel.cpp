#include "saleschartmodel.h"
#include <QDateTime>
SalesChartModel::SalesChartModel(QObject *parent)
    : JsonModel(QJsonArray(),ColumnList(),parent)
{
    connect(this,&QAbstractItemModel::modelReset,this,&SalesChartModel::onEndResetModel);
}

double SalesChartModel::maxValue()
{
    return m_maxValue;
}

double SalesChartModel::minValue()
{
    return m_minValue;
}

void SalesChartModel::onEndResetModel()
{
    double min=m_minValue, max=m_maxValue;
    for(int row=0; row<rowCount(); row++){
        double value=data(row,1).toDouble();

        QVariant dt=data(row,0);
        QDateTime datetime=QDateTime::fromMSecsSinceEpoch(dt.toLongLong());
        qDebug()<<dt;
        qDebug()<<datetime;
        if(value<min){
            min=value;
        }
        if(value>max){
            max=value;
        }
    }
    if(max!=m_maxValue){
        m_maxValue=max;
        emit maxValueChanged(m_maxValue);
    }

    if(min!=m_minValue){
        m_minValue=min;
        emit minValueChanged(m_minValue);
    }
}
