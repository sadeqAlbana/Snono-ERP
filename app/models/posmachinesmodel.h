#ifndef POSMACHINESMODEL_H
#define POSMACHINESMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <appnetworkedjsonmodel.h>

class PosMachinesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PosMachinesModel(QObject *parent = nullptr);
};

#endif // POSMACHINESMODEL_H
