#ifndef CASHIERMODEL_H
#define CASHIERMODEL_H

#include <QAbstractTableModel>
#include "networkedjsonmodel.h"
#include <QSettings>
#include <QQmlEngine>
class CashierModel : public NetworkedJsonModel //make is json model
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double total READ total NOTIFY totalChanged)
public:
    explicit CashierModel(QObject *parent = nullptr);
    virtual void requestData() override;
    virtual void onTableRecieved(NetworkResponse *reply);
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
    Q_INVOKABLE void updateCustomer(const int &customerId);
    int customerId() const;
    Q_INVOKABLE void addProduct(const QJsonValue &id, bool findByBarcode=false);

    void onAddProductReply(NetworkResponse *res);
    Q_INVOKABLE void removeProduct(const int &index);
    void onRemoveProductReply(NetworkResponse *res);
    Q_INVOKABLE void processCart(const double paid,const double change, const QString &note=QString(), const QJsonObject &deliveryInfo=QJsonObject());;
    void onProcessCartRespnse(NetworkResponse *res);
    Q_INVOKABLE void requestCart();
    void onRequestCartResponse(NetworkResponse *res);
    void onUpadteCustomerReply(NetworkResponse *res);
    virtual QJsonArray filterData(QJsonArray data) override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;


signals:
    void purchaseResponseReceived(QJsonObject res);
    void updateCustomerResponseReceived(QJsonObject  res);
    void totalChanged(double total);
    void addProductReply(QJsonObject res);


private:
    void onProductDataRecevied(NetworkResponse *res);
    QJsonObject _cartData;
    QString _reference;
    QModelIndex _changedIndex;
    QSettings settings;
};

#endif // CASHIERMODEL_H
