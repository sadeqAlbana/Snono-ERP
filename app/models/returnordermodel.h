#ifndef RETURNORDERMODEL_H
#define RETURNORDERMODEL_H

#include <QObject>

#include "jsonmodel.h"
class ReturnOrderModel : public JsonModel
{
    Q_OBJECT
    Q_PROPERTY(double returnTotal READ returnTotal NOTIFY returnTotalChanged)

public:
    explicit ReturnOrderModel(const QJsonArray &data=QJsonArray(), QObject *parent = nullptr);

    virtual bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    double returnTotal();
    Q_INVOKABLE void refreshReturnTotal();

    Q_INVOKABLE QJsonArray returnedLines();

signals:
    void returnTotalChanged(double returnTotal);

};

#endif // RETURNORDERMODEL_H
