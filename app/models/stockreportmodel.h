#ifndef STOCKREPORTMODEL_H
#define STOCKREPORTMODEL_H

#include "appnetworkedjsonmodel.h"

class StockReportModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit StockReportModel(QObject *parent = nullptr);
    Q_INVOKABLE void print();
    Q_INVOKABLE void printCSV();

private:
    bool test;
signals:

};

#endif // STOCKREPORTMODEL_H
