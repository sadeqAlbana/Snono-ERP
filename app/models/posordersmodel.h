#ifndef POSORDERSMODEL_H
#define POSORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class PosOrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PosOrdersModel(QObject *parent = nullptr);

    Q_INVOKABLE void returnOrder(const int &orderId, const QJsonArray items);
    Q_INVOKABLE void returnableItems(const int &orderId);
    virtual QJsonArray filterData(QJsonArray data) override;
    Q_INVOKABLE void print();


signals:
    void returnOrderResponse(QJsonObject reply);
    void returnableItemsResponse(QJsonObject reply);


};

#endif // POSORDERSMODEL_H
