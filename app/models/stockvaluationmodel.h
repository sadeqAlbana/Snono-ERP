#ifndef STOCKVALUATIONMODEL_H
#define STOCKVALUATIONMODEL_H

#include "appnetworkedjsonmodel.h"
#include <QQmlEngine>

class StockValuationModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit StockValuationModel(QObject *parent = nullptr);
};

#endif // STOCKVALUATIONMODEL_H
