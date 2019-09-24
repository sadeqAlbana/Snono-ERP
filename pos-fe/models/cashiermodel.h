#ifndef CASHIERMODEL_H
#define CASHIERMODEL_H

#include <QAbstractTableModel>
#include <networkmanager.h>
class CashierModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit CashierModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Add data:
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool insertColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

    // Remove data:
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool removeColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

    void addItem(int barcode);

    void reset();
    QJsonArray items();
    qreal total();
private:
    QList<QString> m_headerData;
    QVector<QVariantList> m_data;
    void onItemDataRecieved(NetworkResponse *res);
    NetworkManager manager;

signals:
    void totalChanged(qreal total);
};

#endif // CASHIERMODEL_H
