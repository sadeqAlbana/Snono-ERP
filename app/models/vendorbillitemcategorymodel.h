#ifndef VENDORBILLITEMCATEGORYMODEL_H
#define VENDORBILLITEMCATEGORYMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class VendorBillItemCategoryModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit VendorBillItemCategoryModel(QObject *parent = nullptr);
};

#endif // VENDORBILLITEMCATEGORYMODEL_H
