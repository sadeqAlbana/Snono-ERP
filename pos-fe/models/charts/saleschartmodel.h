#ifndef SALESCHARTMODEL_H
#define SALESCHARTMODEL_H

#include <jsonmodel.h>

class SalesChartModel : public JsonModel
{
    Q_OBJECT
public:
    Q_INVOKABLE explicit SalesChartModel(QObject *parent = nullptr);

signals:

};

#endif // SALESCHARTMODEL_H
