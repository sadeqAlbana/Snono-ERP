#ifndef NEWINVOICEMODEL_H
#define NEWINVOICEMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>

class NewInvoiceModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit NewInvoiceModel(QObject *parent = nullptr);

    Qt::ItemFlags flags(const QModelIndex& index) const override;
    Q_INVOKABLE void newEntry();
};

#endif // NEWINVOICEMODEL_H
