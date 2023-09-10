#ifndef STOCKLOCATIONMODEL_H
#define STOCKLOCATIONMODEL_H

#include "appnetworkedjsonmodel.h"
#include <QObject>
#include <QQmlEngine>

class StockLocationModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit StockLocationModel(QObject *parent = nullptr);
};

#endif // STOCKLOCATIONMODEL_H
