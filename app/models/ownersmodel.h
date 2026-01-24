#ifndef OWNERSMODEL_H
#define OWNERSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class OwnersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OwnersModel(QObject *parent = nullptr);
};

#endif // OWNERSMODEL_H
