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

signals:
    void maxValueChanged(double maxValue);
    void minValueChanged(double minValue);
private:
    void onEndResetModel();
    double m_maxValue=0;
    double m_minValue=0;

};

#endif // SALESCHARTMODEL_H
