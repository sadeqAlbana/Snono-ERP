#ifndef EMPLOYEESMODEL_H
#define EMPLOYEESMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class EmployeesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit EmployeesModel(QObject *parent = nullptr);
};

#endif // EMPLOYEESMODEL_H
