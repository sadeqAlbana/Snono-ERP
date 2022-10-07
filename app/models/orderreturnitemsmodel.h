#ifndef ORDERRETURNITEMSMODEL_H
#define ORDERRETURNITEMSMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>
class OrderReturnItemsModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit OrderReturnItemsModel(QObject *parent = nullptr);

signals:

};

#endif // ORDERRETURNITEMSMODEL_H
