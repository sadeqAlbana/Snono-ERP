#ifndef CUSTOMERSMODEL_H
#define CUSTOMERSMODEL_H

#include "jsonModel/networkedjsonmodel.h"

class CustomersModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit CustomersModel(QObject *parent = nullptr);

    virtual ColumnList columns() const override;
};

#endif // CUSTOMERSMODEL_H
