#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "appnetworkedjsonmodel.h"

class AccountsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit AccountsModel(QObject *parent = nullptr);

signals:
};

#endif // ACCOUNTSMODEL_H
