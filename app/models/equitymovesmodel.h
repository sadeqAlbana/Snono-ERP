#ifndef EQUITYMOVESMODEL_H
#define EQUITYMOVESMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class EquityMovesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit EquityMovesModel(QObject *parent = nullptr);
};

#endif // EQUITYMOVESMODEL_H
