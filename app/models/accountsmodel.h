#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "appnetworkedjsonmodel.h"
class AccountsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit AccountsModel(QObject *parent = nullptr);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

signals:
};

#endif // ACCOUNTSMODEL_H
