#ifndef PORDUCTSMODEL_H
#define PORDUCTSMODEL_H

#include "models/jsonModel/networkedjsonmodel.h"

class ProductsModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    ProductsModel(QObject *parent=nullptr);
    virtual ColumnList columns() const override;

    void updateProduct(const QJsonObject &product);
    void onUpdateProductReply(NetworkResponse *res);

signals:
    void productUpdateReply(QJsonObject reply);
};

#endif // PORDUCTSMODEL_H
