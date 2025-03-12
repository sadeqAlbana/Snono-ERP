#ifndef STOCKRESERVATIONSMODEL_H
#define STOCKRESERVATIONSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class StockReservationsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit StockReservationsModel(QObject *parent = nullptr);
};

#endif // STOCKRESERVATIONSMODEL_H
