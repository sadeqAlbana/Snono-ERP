#ifndef PAYMENTREFUNDSMODEL_H
#define PAYMENTREFUNDSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PaymentRefundsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit PaymentRefundsModel(QObject *parent = nullptr);
};

#endif // PAYMENTREFUNDSMODEL_H
