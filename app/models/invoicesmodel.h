#ifndef INVOICESMODEL_H
#define INVOICESMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class InvoicesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit InvoicesModel(QObject *parent = nullptr);
};

#endif // INVOICESMODEL_H
