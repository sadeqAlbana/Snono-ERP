#ifndef API_H
#define API_H

#include <QObject>
#include <QJsonObject>
//this class will be used to make all  api calls in the future !
class Api : public QObject
{
    Q_OBJECT
public:
    explicit Api(QObject *parent = nullptr);
    Q_INVOKABLE void processCustomBill(const QString &name, const int &vendorId,const QJsonArray &items);
    Q_INVOKABLE void updateProduct(const QJsonObject &product);

    Q_INVOKABLE void updateProduct(const int &productId, const QString &name, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes);
    Q_INVOKABLE void requestDashboard();

signals:
    void processCustomBillResponse(QJsonObject reply);
    void updateProductReply(QJsonObject reply);
    void dashboardReply(QJsonObject reply);

};

#endif // API_H
