#ifndef ORDERSMODEL_H
#define ORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class OrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit OrdersModel(QObject *parent = nullptr);

    Q_INVOKABLE void updateDeliveryStatus(const int &orderId, const QString &status);
    Q_INVOKABLE void returnOrder(const int &orderId, const QJsonArray items);


signals:
    void updateDeliveryStatusResponse(QJsonObject reply);
    void returnOrderResponse(QJsonObject reply);

};

#endif // ORDERSMODEL_H
