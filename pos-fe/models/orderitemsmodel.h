#ifndef ORDERITEMSMODEL_H
#define ORDERITEMSMODEL_H

#include "models/jsonModel/jsonmodel.h"

class OrderItemsModel : public JsonModel
{
    Q_OBJECT
public:
    explicit OrderItemsModel(const QJsonArray &data, QObject *parent = nullptr);


    virtual ColumnList columns() const;


};

#endif // ORDERITEMSMODEL_H
