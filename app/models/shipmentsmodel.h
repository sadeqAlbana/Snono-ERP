#ifndef SHIPMENTSMODEL_H
#define SHIPMENTSMODEL_H
#include "appnetworkedjsonmodel.h"

class ShipmentsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit ShipmentsModel(QObject *parent = nullptr);

    Q_INVOKABLE virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

};

#endif // SHIPMENTSMODEL_H
