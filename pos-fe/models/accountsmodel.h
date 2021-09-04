#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "appnetworkedjsonmodel.h"

class AccountsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit AccountsModel(QObject *parent = nullptr);


    void depositCash(const int &creditorId, const double &amount);
    void onDepostCashResponse(NetworkResponse *res);

signals:
    void depositCashResponseReceived(QJsonObject response);
};

#endif // ACCOUNTSMODEL_H
