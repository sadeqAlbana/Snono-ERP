#ifndef API_H
#define API_H

#include "networkresponse.h"
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
//this class will be used to make all  api calls in the future !
class Api : public QObject
{
    Q_OBJECT
    explicit Api(QObject *parent = nullptr);

public:
    Q_INVOKABLE void depositCash(const double &amount);

    Q_INVOKABLE void processCustomBill(const QString &name, const int &vendorId,const QJsonArray &items);
    Q_INVOKABLE void updateProduct(const QJsonObject &product);

    Q_INVOKABLE void updateProduct(const int &productId, const QString &name, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes);
    Q_INVOKABLE void requestDashboard();
    static Api *instance();

    Q_INVOKABLE void addCategory(const QString &name, const int &parentId);
    Q_INVOKABLE void removeCategory(const int &categoryId);
    Q_INVOKABLE void barqReceipt(const int orderId);
    Q_INVOKABLE void adjustStock(const int productId, const int newQty, const QString &reason);
    Q_INVOKABLE bool bulckStockAdjustment(const QUrl &url);
    Q_INVOKABLE void returnBill(const int billId, const QJsonArray &items=QJsonArray());

    Q_INVOKABLE void generateImages();

    Q_INVOKABLE NetworkResponse * addVendor(const QJsonObject &data);
    Q_INVOKABLE void returnableItems(const int &orderId);
    Q_INVOKABLE void returnOrder(const int &orderId, const QJsonArray items);
     void addCustomer(const QString name, const QString firstName, const QString lastName, const QString email, const QString phone, const QString address);
    Q_INVOKABLE NetworkResponse *  addCustomer(const QJsonObject &data);
    Q_INVOKABLE NetworkResponse * updateCustomer(const QJsonObject &data);


    Q_INVOKABLE NetworkResponse * updateVendor(const QJsonObject &data);

    Q_INVOKABLE void payBill(const int &vendorBillId);
    Q_INVOKABLE void createBill(const int &vendorId, const QJsonArray &products);


    Q_INVOKABLE NetworkResponse * addUser(const QJsonObject &data);
    Q_INVOKABLE NetworkResponse * updateUser(const QJsonObject &data);







signals:
    void processCustomBillResponse(QJsonObject reply);
    void updateProductReply(QJsonObject reply);
    void dashboardReply(QJsonObject reply);
    void depositCashResponseReceived(QJsonObject reply);

    void categoryAddReply(QJsonObject reply);
    void categoryRemoveReply(QJsonObject reply);
    void barqReceiptReply(const QByteArray &reply);
    void adjustStockReply(const QJsonObject &reply);
    void bulckStockAdjustmentReply(const QJsonObject &reply);
    void billReturnReply(const QJsonObject &reply);
    void returnOrderResponse(QJsonObject reply);
    void returnableItemsResponse(QJsonObject reply);
    void addCustomerReply(QJsonObject reply);

    void payBillReply(QJsonObject reply);
    void createBillReply(QJsonObject reply);

private:
    static Api *m_api;

};

#endif // API_H
