#ifndef DRIVERSMODEL_H
#define DRIVERSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class DriversModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit DriversModel(QObject *parent = nullptr);
};

#endif // DRIVERSMODEL_H
