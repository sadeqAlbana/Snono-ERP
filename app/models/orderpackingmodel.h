#ifndef ORDERPACKINGMODEL_H
#define ORDERPACKINGMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>

class OrderPackingModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OrderPackingModel(QObject *parent = nullptr);
    virtual bool setData(const QModelIndex &index, const QVariant &value,
                         int role = Qt::EditRole) override;

    Q_INVOKABLE bool add(const QString barcode);
};

#endif // ORDERPACKINGMODEL_H
