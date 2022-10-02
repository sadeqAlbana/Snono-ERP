#ifndef BARQLOCATIONSMODEL_H
#define BARQLOCATIONSMODEL_H

#include "appnetworkedjsonmodel.h"

class BarqLocationsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit BarqLocationsModel(QObject *parent = nullptr);

signals:

};

#endif // BARQLOCATIONSMODEL_H
