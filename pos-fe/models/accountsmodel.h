#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "appnetworkedjsonmodel.h"

class AccountsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit AccountsModel(QObject *parent = nullptr);


    Q_INVOKABLE void depositCash(const double &amount);
    void onDepostCashResponse(NetworkResponse *res);

signals:
    void depositCashResponseReceived(QJsonObject reply);
};

#endif // ACCOUNTSMODEL_H
