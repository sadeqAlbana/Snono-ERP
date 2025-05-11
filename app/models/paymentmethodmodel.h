#ifndef PAYMENTMETHODMODEL_H
#define PAYMENTMETHODMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PaymentMethodModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit PaymentMethodModel(QObject *parent = nullptr);
};

#endif // PAYMENTMETHODMODEL_H
