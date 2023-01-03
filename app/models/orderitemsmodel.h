#ifndef ORDERITEMSMODEL_H
#define ORDERITEMSMODEL_H

#include "qmljsonmodel.h"
#include <QQmlEngine>

class OrderItemsModel : public QmlJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit OrderItemsModel(QObject *parent = nullptr);
};

#endif // ORDERITEMSMODEL_H
