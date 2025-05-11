#ifndef PAYMENTMETHODSMODEL_H
#define PAYMENTMETHODSMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class PaymentMethodsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PaymentMethodsModel(QObject *parent = nullptr);
};

#endif // PAYMENTMETHODSMODEL_H
