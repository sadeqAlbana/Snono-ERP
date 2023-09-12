#ifndef STOCKMOVESMODEL_H
#define STOCKMOVESMODEL_H

#include "appnetworkedjsonmodel.h"
#include <QQmlEngine>

class StockMovesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit StockMovesModel(QObject *parent = nullptr);
};

#endif // STOCKMOVESMODEL_H
