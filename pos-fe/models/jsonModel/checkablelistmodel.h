#ifndef CHECKABLELISTMODEL_H
#define CHECKABLELISTMODEL_H

#include "networkedjsonmodel.h"

class CheckableListModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit CheckableListModel(const QString &displayColumn,
                                const QString &dataColumn,
                                const QSet<int> original,
                                const QString& url,
                                QObject *parent = nullptr);
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    ColumnList columns() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    QJsonArray selectedRows();

private:
    QString displayColumn;
    QString dataColumn;
    QSet<int> selected;
    QSet<int> originalSelectedIds;
    void onDataRecevied();
};

#endif // CHECKABLELISTMODEL_H
