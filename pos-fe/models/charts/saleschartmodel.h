#ifndef SALESCHARTMODEL_H
#define SALESCHARTMODEL_H

#include <jsonmodel.h>

class SalesChartModel : public JsonModel
{
    Q_OBJECT
    Q_PROPERTY(double maxValue READ maxValue NOTIFY maxValueChanged)
    Q_PROPERTY(double minValue READ minValue NOTIFY minValueChanged)
public:
    Q_INVOKABLE explicit SalesChartModel(QObject *parent = nullptr);
    double maxValue();
    double minValue();

    const QDateTime &minDate() const;
    void setMinDate(const QDateTime &newMinDate);

    const QDateTime &maxDate() const;
    void setMaxDate(const QDateTime &newMaxDate);

    qint64 minDateUTC() const;
    void setMinDateUTC(qint64 newMinDateUTC);

    qint64 maxDateUTC() const;
    void setMaxDateUTC(qint64 newMaxDateUTC);

signals:
    void maxValueChanged();
    void minValueChanged();
    void minDateChanged();

    void maxDateChanged();

    void minDateUTCChanged();

    void maxDateUTCChanged();

private:
    void onEndResetModel();
    double m_maxValue=0;
    double m_minValue=0;

    QDateTime m_minDate;
    QDateTime m_maxDate;
    qint64 m_minDateUTC=0;
    qint64 m_maxDateUTC=0;

    Q_PROPERTY(QDateTime minDate READ minDate WRITE setMinDate NOTIFY minDateChanged)
    Q_PROPERTY(QDateTime maxDate READ maxDate WRITE setMaxDate NOTIFY maxDateChanged)
    Q_PROPERTY(qint64 minDateUTC READ minDateUTC WRITE setMinDateUTC NOTIFY minDateUTCChanged)
    Q_PROPERTY(qint64 maxDateUTC READ maxDateUTC WRITE setMaxDateUTC NOTIFY maxDateUTCChanged)
};

#endif // SALESCHARTMODEL_H
