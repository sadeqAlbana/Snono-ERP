#ifndef VENDORSBILLSMODEL_H
#define VENDORSBILLSMODEL_H

#include "appnetworkedjsonmodel.h"

class VendorsBillsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit VendorsBillsModel(QObject *parent = nullptr);

    Q_INVOKABLE void payBill(const int &vendorBillId);

signals:
    void payBillReply(QJsonObject reply);

};

#endif // VENDORSBILLSMODEL_H
