#ifndef VENDORSMODEL_H
#define VENDORSMODEL_H

#include "appnetworkedjsonmodel.h"

class VendorsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit VendorsModel(QObject *parent = nullptr);

    Q_INVOKABLE void addVendor(const QString &name, const QString &email, const QString &address, const QString &phone);
    Q_INVOKABLE void removeVendor(const int &vendorId);


signals:
    void vendorAddReply(QJsonObject reply);
    void vendorRemoveReply(QJsonObject reply);

};

#endif // VENDORSMODEL_H
