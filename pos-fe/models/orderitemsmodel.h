#ifndef ORDERITEMSMODEL_H
#define ORDERITEMSMODEL_H

#include "jsonmodel.h"

class OrderItemsModel : public JsonModel
{
    Q_OBJECT
public:
    explicit OrderItemsModel(const QJsonArray &data=QJsonArray(), QObject *parent = nullptr);
};

#endif // ORDERITEMSMODEL_H
