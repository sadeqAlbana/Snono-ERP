#ifndef CASHIERMODEL_H
#define CASHIERMODEL_H

#include <QAbstractTableModel>
#include "jsonModel/networkedjsonmodel.h"
class CashierModel : public NetworkedJsonModel //make is json model
{
    Q_OBJECT

public:
    explicit CashierModel(QObject *parent = nullptr);
    virtual void requestData() override;
    ColumnList columns() const override;
    virtual void onTableRecieved(NetworkResponse *reply) override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    void onDataChange(NetworkResponse *res);
    double total();
    double taxAmount();
    QString totalCurrencyString();
    QString taxAmountCurrencyString();

    QJsonObject cartData() const;
    void setCartData(const QJsonObject &cartData);

    QString reference() const;
    void setReference(const QString &reference);

    QModelIndex changedIndex() const;
    void setChangedIndex(const QModelIndex &changedIndex);

    void addProduct(const QString &barcode);
    void onAddProductReply(NetworkResponse *res);
    void removeProduct(const int &index);
    void onRemoveProductReply(NetworkResponse *res);
    void processCart(const double paid,const double change);
    void onProcessCartRespnse(NetworkResponse *res);
    void requestCart();
    void onRequestCartResponse(NetworkResponse *res);

signals:
    void purchaseResponseReceived(QJsonObject res);

private:
    void onProductDataRecevied(NetworkResponse *res);
    QJsonObject _cartData;
    QString _reference;
    QModelIndex _changedIndex;
    QSettings settings;
};

#endif // CASHIERMODEL_H
