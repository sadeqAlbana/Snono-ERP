#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "jsonModel/networkedjsonmodel.h"

class AccountsModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit AccountsModel(QObject *parent = nullptr);

    virtual ColumnList columns() const override;

    void depositCash(const int &creditorId, const double &amount);
    void onDepostCashResponse(NetworkResponse *res);

signals:
    void depositCashResponseReceived(QJsonObject response);
};

#endif // ACCOUNTSMODEL_H
