#ifndef RECEIPTMODEL_H
#define RECEIPTMODEL_H

#include "appnetworkedjsonmodel.h"

class ReceiptModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit ReceiptModel(const int &orderId, QObject *parent = nullptr);
    virtual void requestData() override;
    virtual void onTableRecieved(NetworkResponse *reply);

signals:

private:
    int m_orderId;
    QJsonObject m_orderData;

};

#endif // RECEIPTMODEL_H
