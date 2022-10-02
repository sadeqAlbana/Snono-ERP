#ifndef CUSTOMERSMODEL_H
#define CUSTOMERSMODEL_H

#include "appnetworkedjsonmodel.h"

class CustomersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit CustomersModel(QObject *parent = nullptr);
    Q_INVOKABLE void addCustomer(const QString name, const QString firstName, const QString lastName, const QString email, const QString phone, const QString address);

signals:
    void addCustomerReply(QJsonObject reply);
};

#endif // CUSTOMERSMODEL_H
