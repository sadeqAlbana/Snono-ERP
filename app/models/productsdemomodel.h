#ifndef PRODUCTSDEMOMODEL_H
#define PRODUCTSDEMOMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class ProductsDemoModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ProductsDemoModel(QObject *parent = nullptr);
};

#endif // PRODUCTSDEMOMODEL_H
