#ifndef LOCATIONSMODEL_H
#define LOCATIONSMODEL_H

#include "appnetworkedjsonmodel.h"
#include <QQmlEngine>

class LocationsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit LocationsModel(QObject *parent = nullptr);
};

#endif // LOCATIONSMODEL_H
