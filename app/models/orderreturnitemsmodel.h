#ifndef ORDERRETURNITEMSMODEL_H
#define ORDERRETURNITEMSMODEL_H

#include <QObject>
#include <QQmlEngine>
class OrderReturnItemsModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrderReturnItemsModel(QObject *parent = nullptr);

signals:

};

#endif // ORDERRETURNITEMSMODEL_H
