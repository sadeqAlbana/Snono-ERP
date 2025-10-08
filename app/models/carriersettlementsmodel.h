#ifndef CARRIERSETTLEMENTSMODEL_H
#define CARRIERSETTLEMENTSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class CarrierSettlementsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit CarrierSettlementsModel(QObject *parent = nullptr);
};

#endif // CARRIERSETTLEMENTSMODEL_H
