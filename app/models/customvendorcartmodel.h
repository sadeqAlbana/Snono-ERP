#ifndef CUSTOMVENDORCARTMODEL_H
#define CUSTOMVENDORCARTMODEL_H

#include "jsonmodel.h"
#include <QQmlEngine>
class CustomVendorCartModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
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
