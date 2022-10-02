#ifndef ORDERSRETURNSMODEL_H
#define ORDERSRETURNSMODEL_H

#include "appnetworkedjsonmodel.h"

class OrdersReturnsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrdersReturnsModel(QObject *parent = nullptr);

signals:

};

#endif // ORDERSRETURNSMODEL_H
