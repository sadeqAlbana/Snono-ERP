#ifndef PORDUCTSMODEL_H
#define PORDUCTSMODEL_H

#include "appnetworkedjsonmodel.h"

class ProductsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    ProductsModel(QObject *parent=nullptr);

    Q_INVOKABLE void updateProduct(const QJsonObject &product);
    void onUpdateProductReply(NetworkResponse *res);

    Q_INVOKABLE void updateProductQuantity(const int &index,const double &newQuantity);
    void onUpdateProductQuantityReply(NetworkResponse *res);

    Q_INVOKABLE void purchaseStock(const int &productId, const double &qty, const int &vendorId);
    void onPurchaseStockReply(NetworkResponse *res);


    Q_INVOKABLE void addProduct(const QString &name, const QString &barcode,
                    const double &listPrice, const double &cost, const int &typeId, const QString &description,
                    const int &categoryId, const QList<int> &taxes);

    Q_INVOKABLE void removeProduct(const int &productId);


signals:
    void productUpdateReply(QJsonObject reply);
    void productQuantityUpdated(QJsonObject reply);
    void stockPurchasedReply(QJsonObject reply);
    void productAddReply(QJsonObject reply);
    void productRemoveReply(QJsonObject reply);

};

#endif // PORDUCTSMODEL_H
