#ifndef ORDERSMODEL_H
#define ORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class OrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrdersModel(QObject *parent = nullptr);

    Q_INVOKABLE void updateDeliveryStatus(const int &orderId, const QString &status);
    Q_INVOKABLE void returnOrder(const int &orderId, const QJsonArray items);
    Q_INVOKABLE void returnableItems(const int &orderId);
    virtual QJsonArray filterData(QJsonArray data) override;
    Q_INVOKABLE void print();


signals:
    void updateDeliveryStatusResponse(QJsonObject reply);
    void returnOrderResponse(QJsonObject reply);
    void returnableItemsResponse(QJsonObject reply);


};

#endif // ORDERSMODEL_H
