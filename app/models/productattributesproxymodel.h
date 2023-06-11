
#ifndef PRODUCTATTRIBUTESPROXYMODEL_H
#define PRODUCTATTRIBUTESPROXYMODEL_H

#include <QAbstractProxyModel>
#include <QQmlEngine>


class ProductAttributesProxyModel : public QAbstractProxyModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_INVOKABLE explicit ProductAttributesProxyModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;


    // Basic functionality:
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    // Fetch data dynamically:
    bool hasChildren(const QModelIndex &parent = QModelIndex()) const override;


    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

//    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Add data:
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

    // Remove data:
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

private:

    // QAbstractProxyModel interface


public:
    QModelIndex mapToSource(const QModelIndex &proxyIndex) const override;
    QModelIndex mapFromSource(const QModelIndex &sourceIndex) const override;

    // QAbstractProxyModel interface
    int m_keyColumn;
    int m_valueColumn;
public:
    void setSourceModel(QAbstractItemModel *sourceModel) override;

    // QAbstractItemModel interface
public:
    QModelIndex parent(const QModelIndex &child) const override;

    // QAbstractItemModel interface
public:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // PRODUCTATTRIBUTESPROXYMODEL_H
