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
    if(!rowCount())
        return;

    double min=m_minValue, max=m_maxValue;
    QDateTime minDate=QDateTime(), maxDate=QDateTime();


    for(int row=0; row<rowCount(); row++){
        double value=data(row,1).toDouble();
        QVariant dt=data(row,0);
        QDateTime dateTime=QDateTime::fromMSecsSinceEpoch(dt.toLongLong());


        if((dateTime<minDate || !minDate.isValid()) && dateTime.isValid()){

            minDate=dateTime;
        }
        if((dateTime>maxDate || !maxDate.isValid()) && dateTime.isValid()){
            maxDate=dateTime;
        }
        if(value<min){
            min=value;
        }
        if(value>max){
            max=value;
        }
    }

    if(max!=m_maxValue){
        m_maxValue=max;
        emit maxValueChanged();
    }

    if(min!=m_minValue){
        m_minValue=min;
        emit minValueChanged();
    }


    setMinDate(minDate);
    setMaxDate(maxDate);



    setMinDateUTC(minDate.toMSecsSinceEpoch());

    setMaxDateUTC(maxDate.toMSecsSinceEpoch());

}

qint64 SalesChartModel::maxDateUTC() const
{
    return m_maxDateUTC;
}

void SalesChartModel::setMaxDateUTC(qint64 newMaxDateUTC)
{
    if (m_maxDateUTC == newMaxDateUTC)
        return;
    m_maxDateUTC = newMaxDateUTC;
    emit maxDateUTCChanged();
}



qint64 SalesChartModel::minDateUTC() const
{
    return m_minDateUTC;
}

void SalesChartModel::setMinDateUTC(qint64 newMinDateUTC)
{
    if (m_minDateUTC == newMinDateUTC)
        return;
    m_minDateUTC = newMinDateUTC;
    emit minDateUTCChanged();
}

const QDateTime &SalesChartModel::maxDate() const
{
    return m_maxDate;
}

void SalesChartModel::setMaxDate(const QDateTime &newMaxDate)
{
    if (m_maxDate == newMaxDate)
        return;
    m_maxDate = newMaxDate;
    emit maxDateChanged();
}

const QDateTime &SalesChartModel::minDate() const
{
    return m_minDate;
}

void SalesChartModel::setMinDate(const QDateTime &newMinDate)
{
    if (m_minDate == newMinDate)
        return;
    m_minDate = newMinDate;
    emit minDateChanged();
}
