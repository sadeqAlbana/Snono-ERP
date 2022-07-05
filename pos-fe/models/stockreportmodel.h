#ifndef STOCKREPORTMODEL_H
#define STOCKREPORTMODEL_H

#include "appnetworkedjsonmodel.h"

class StockReportModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    Q_INVOKABLE explicit StockReportModel(QObject *parent = nullptr);
    Q_INVOKABLE void print();
signals:

};

#endif // STOCKREPORTMODEL_H
