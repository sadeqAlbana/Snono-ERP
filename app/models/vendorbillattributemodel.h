#ifndef VENDORBILLATTRIBUTEMODEL_H
#define VENDORBILLATTRIBUTEMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class VendorBillAttributeModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit VendorBillAttributeModel(QObject *parent = nullptr);
};

#endif // VENDORBILLATTRIBUTEMODEL_H
