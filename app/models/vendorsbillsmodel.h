#ifndef VENDORSBILLSMODEL_H
#define VENDORSBILLSMODEL_H

#include "appnetworkedjsonmodel.h"

class VendorsBillsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit VendorsBillsModel(QObject *parent = nullptr);

    Q_INVOKABLE void payBill(const int &vendorBillId);
    Q_INVOKABLE void createBill(const int &vendorId, const QJsonArray &products);


signals:
    void payBillReply(QJsonObject reply);
    void createBillReply(QJsonObject reply);

};

#endif // VENDORSBILLSMODEL_H
