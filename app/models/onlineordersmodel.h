#ifndef ONLINEORDERSMODEL_H
#define ONLINEORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class OnlineOrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit OnlineOrdersModel(QObject *parent = nullptr);

    Q_INVOKABLE void updateDeliveryStatus(const int &orderId, const QString &status);
    Q_INVOKABLE void returnOrder(const int &orderId, const QJsonArray items);
    Q_INVOKABLE void returnableItems(const int &orderId);
    virtual QJsonArray filterData(QJsonArray data) override;
    Q_INVOKABLE void print();
    Q_INVOKABLE virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;


signals:
    void updateDeliveryStatusResponse(QJsonObject reply);
    void returnOrderResponse(QJsonObject reply);
    void returnableItemsResponse(QJsonObject reply);


};

#endif // ONLINEORDERSMODEL_H
