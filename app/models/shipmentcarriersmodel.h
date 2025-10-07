#ifndef SHIPMENTCARRIERSMODEL_H
#define SHIPMENTCARRIERSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class ShipmentCarriersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ShipmentCarriersModel(QObject *parent = nullptr);
};

#endif // SHIPMENTCARRIERSMODEL_H
