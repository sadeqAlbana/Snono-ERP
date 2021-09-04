#ifndef ORDERSMODEL_H
#define ORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class OrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit OrdersModel(QObject *parent = nullptr);

};

#endif // ORDERSMODEL_H
