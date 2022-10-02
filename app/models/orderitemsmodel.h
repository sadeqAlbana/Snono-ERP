#ifndef ORDERITEMSMODEL_H
#define ORDERITEMSMODEL_H

#include "jsonmodel.h"
#include <QQmlEngine>

class OrderItemsModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrderItemsModel(const QJsonArray &data=QJsonArray(), QObject *parent = nullptr);
};

#endif // ORDERITEMSMODEL_H
