#ifndef PAYROLLRUNSMODEL_H
#define PAYROLLRUNSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PayrollRunsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PayrollRunsModel(QObject *parent = nullptr);
};

#endif // PAYROLLRUNSMODEL_H
