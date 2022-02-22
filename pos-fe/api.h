#ifndef API_H
#define API_H

#include <QObject>
#include <QJsonObject>
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


signals:
    void processCustomBillResponse(QJsonObject reply);
    void updateProductReply(QJsonObject reply);
    void dashboardReply(QJsonObject reply);
    void depositCashResponseReceived(QJsonObject reply);

    void categoryAddReply(QJsonObject reply);
    void categoryRemoveReply(QJsonObject reply);


private:
    static Api *m_api;

};

#endif // API_H
