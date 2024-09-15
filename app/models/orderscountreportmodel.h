#ifndef ORDERSCOUNTREPORTMODEL_H
#define ORDERSCOUNTREPORTMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class OrdersCountReportModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrdersCountReportModel(QObject *parent = nullptr);
};

#endif // ORDERSCOUNTREPORTMODEL_H
