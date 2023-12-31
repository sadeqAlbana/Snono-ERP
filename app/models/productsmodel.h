#ifndef PORDUCTSMODEL_H
#define PORDUCTSMODEL_H

#include "appnetworkedjsonmodel.h"

class ProductsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    ProductsModel(QObject *parent=nullptr);

    Q_INVOKABLE void updateProduct(const QJsonObject &product);
    Q_INVOKABLE void updateProduct(const int &productId, const QString &name, const QString &barcode, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes);

    void onUpdateProductReply(NetworkResponse *res);

    Q_INVOKABLE void updateProductQuantity(const int &index,const double &newQuantity);
    void onUpdateProductQuantityReply(NetworkResponse *res);

    Q_INVOKABLE void purchaseStock(const int &productId, const double &qty, const int &vendorId);
    void onPurchaseStockReply(NetworkResponse *res);


    Q_INVOKABLE void addProduct(const QString &name, const QString &barcode,
                    const double &listPrice, const double &cost, const int &typeId, const QString &description,
                    const int &categoryId, const QList<int> &taxes,const int &parentId=0);

    Q_INVOKABLE void removeProduct(const int &productId);

    Q_INVOKABLE  QVariantMap jsonMap(const int &row);

    Q_INVOKABLE void exportJson();

    virtual QJsonArray filterData(QJsonArray data) override;




signals:
    void productUpdateReply(QJsonObject reply);
    void productQuantityUpdated(QJsonObject reply);
    void stockPurchasedReply(QJsonObject reply);
    void productAddReply(QJsonObject reply);
    void productRemoveReply(QJsonObject reply);

protected:
    void onTableRecieved(NetworkResponse *reply) override;
private:
    QJsonArray m_wantedColumns;

};

#endif // PORDUCTSMODEL_H
