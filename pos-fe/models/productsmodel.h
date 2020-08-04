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

    void updateProductQuantity(const int &index,const double &newQuantity);
    void onUpdateProductQuantityReply(NetworkResponse *res);

    void purchaseStock(const int &index,const double &qty);
    void onPurchaseStockReply(NetworkResponse *res);

signals:
    void productUpdateReply(QJsonObject reply);
    void productQuantityUpdated(QJsonObject reply);
    void stockPurchased(QJsonObject reply);
};

#endif // PORDUCTSMODEL_H
