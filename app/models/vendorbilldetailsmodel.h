#ifndef VENDORBILLDETAILSMODEL_H
#define VENDORBILLDETAILSMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>

class VendorBillDetailsModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit VendorBillDetailsModel(QObject *parent = nullptr);
};

#endif // VENDORBILLDETAILSMODEL_H
