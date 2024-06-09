#ifndef SHIPMENTSMODEL_H
#define SHIPMENTSMODEL_H
#include "appnetworkedjsonmodel.h"

class ShipmentsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit ShipmentsModel(QObject *parent = nullptr);
};

#endif // SHIPMENTSMODEL_H
