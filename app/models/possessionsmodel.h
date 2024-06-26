#ifndef POSSESSIONSMODEL_H
#define POSSESSIONSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PosSessionsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PosSessionsModel(QObject *parent = nullptr);
};

#endif // POSSESSIONSMODEL_H
