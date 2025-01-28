#ifndef PAYMENTSMODEL_H
#define PAYMENTSMODEL_H

#include <QObject>
#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PaymentsModel : public AppNetworkedJsonModel
{
    QML_ELEMENT
public:
    explicit PaymentsModel(QObject *parent = nullptr);
};

#endif // PAYMENTSMODEL_H
