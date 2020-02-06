#ifndef PORDUCTSMODEL_H
#define PORDUCTSMODEL_H

#include "models/jsonModel/networkedjsonmodel.h"

class ProductsModel : public NetworkedJsonModel
{
public:
    ProductsModel(QObject *parent=0);
    virtual void requestData() override;
    virtual ColumnList columns() const override;
};

#endif // PORDUCTSMODEL_H
