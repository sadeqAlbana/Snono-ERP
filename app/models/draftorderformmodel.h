#ifndef DRAFTORDERFORMMODEL_H
#define DRAFTORDERFORMMODEL_H

#include <QQmlEngine>
#include <jsonmodel.h>

class DraftOrderFormModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double cartTotal READ cartTotal NOTIFY cartTotalChanged)

public:
    explicit DraftOrderFormModel(QObject *parent = nullptr);
    virtual bool setData(const QModelIndex &index, const QVariant &value,
                         int role = Qt::EditRole) override;
    double cartTotal();
    Q_INVOKABLE void refreshCartTotal();



signals:
    void cartTotalChanged();
};

#endif // DRAFTORDERFORMMODEL_H
