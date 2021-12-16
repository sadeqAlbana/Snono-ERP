#ifndef CHECKABLELISTMODEL_H
#define CHECKABLELISTMODEL_H

#include "../appnetworkedjsonmodel.h"
#include <QSet>
class CheckableListModel : public AppNetworkedJsonModel
{
    Q_OBJECT

    Q_PROPERTY(QString selectedItems READ selectedItems NOTIFY selectedItemsChanged)

public:
    explicit CheckableListModel(const QString &displayColumn,
                                const QString &dataColumn,
                                const QSet<int> original,
                                const QString& url,
                                QObject *parent = nullptr);
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    virtual QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE QJsonArray selectedRows();

    Q_INVOKABLE QString selectedItems() const; //used for combobox display text
    Q_INVOKABLE QList<int> selectedIds();

signals:
    void selectedItemsChanged();

private:
    QString displayColumn;
    QString dataColumn;
    QSet<int> selected;
    QSet<int> originalSelectedIds;
    void onDataRecevied();
};

#endif // CHECKABLELISTMODEL_H
