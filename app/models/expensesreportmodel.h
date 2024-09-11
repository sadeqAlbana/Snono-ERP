#ifndef EXPENSESREPORTMODEL_H
#define EXPENSESREPORTMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class ExpensesReportModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ExpensesReportModel(QObject *parent = nullptr);
};

#endif // EXPENSESREPORTMODEL_H
