#ifndef CUSTOMVENDORCARTMODEL_H
#define CUSTOMVENDORCARTMODEL_H

#include "jsonmodel.h"

class CustomVendorCartModel : public JsonModel
{
    Q_OBJECT
    Q_PROPERTY(double cartTotal READ cartTotal NOTIFY cartTotalChanged)

public:
    explicit CustomVendorCartModel(QObject *parent = nullptr);
    virtual bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    double cartTotal();
    Q_INVOKABLE void refreshCartTotal();



signals:
    void cartTotalChanged(double cartTotal);



};

#endif // CUSTOMVENDORCARTMODEL_H
