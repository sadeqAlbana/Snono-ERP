#ifndef RECEIPTMODEL_H
#define RECEIPTMODEL_H

#include "appnetworkedjsonmodel.h"

class ReceiptModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double total READ total NOTIFY totalChanged)
    Q_PROPERTY(double taxAmount READ taxAmount NOTIFY taxAmountChanged)

    Q_PROPERTY(QString reference READ reference NOTIFY referenceChanged)
    Q_PROPERTY(QString customer READ customer NOTIFY customerChanged)
    Q_PROPERTY(QString address READ address NOTIFY addressChanged)
    Q_PROPERTY(QString phone READ phone NOTIFY phoneChanged)
    Q_PROPERTY(QString date READ date NOTIFY dateChanged)




public:
    explicit ReceiptModel(QObject *parent = nullptr);
    virtual void requestData() override;
    virtual void onTableRecieved(NetworkResponse *reply);
    double total();
    double taxAmount();
    QString reference();
    QString customer();
    QString address();
    QString phone();
    QString date();





signals:
    void dataReceived();
    void totalChanged(double total);
    void taxAmountChanged(double taxAmount);
    void referenceChanged(QString reference);
    void customerChanged(QString customer);
    void addressChanged(QString address);
    void phoneChanged(QString phone);
    void dateChanged(QString date);






private:
    int m_orderId;
    QJsonObject m_orderData;

};

#endif // RECEIPTMODEL_H
