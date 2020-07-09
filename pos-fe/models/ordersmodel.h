#ifndef ORDERSMODEL_H
#define ORDERSMODEL_H

#include "models/jsonModel/networkedjsonmodel.h"

class OrdersModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit OrdersModel(QObject *parent = nullptr);
    virtual ColumnList columns() const override;

};

#endif // ORDERSMODEL_H
