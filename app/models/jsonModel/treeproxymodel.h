#ifndef TREEPROXYMODEL_H
#define TREEPROXYMODEL_H

#include <QAbstractProxyModel>
#include <QQmlEngine>


class TreeProxyModel : public QAbstractProxyModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit TreeProxyModel(QObject *parent = nullptr);

    virtual QModelIndex mapFromSource(const QModelIndex &sourceIndex) const override;
    virtual QModelIndex mapToSource(const QModelIndex &proxyIndex) const override;
    virtual QModelIndex parent(const QModelIndex &child) const override;

    virtual QModelIndex index(int row, int column, const QModelIndex &parent) const override;
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const override;
    virtual int columnCount(const QModelIndex &parent) const override;

    virtual QVariant headerData (int section, Qt::Orientation orientation, int role) const override { return sourceModel()->headerData(section,orientation,role); }
    virtual bool setHeaderData(int section, Qt::Orientation orientation, const  QVariant &value, int role) override { return sourceModel()->setHeaderData(section,orientation,value,role); }

    inline virtual bool hasChildren(const QModelIndex &parent) const override{return hasChildren(parent.internalId());} //inline it or not ?
    virtual bool hasChildren(const int ParentID) const;
    virtual Qt::ItemFlags flags(const QModelIndex &index) const override;


    virtual int level(QModelIndex index);


private:
    int getParentId(int childId) const;

    int childNumber(int ID) const;
    int GetID(int ParentID, int row) const;
    int  IDColumn=0;
    int pIDColumn=1;
    int DataColumn=2;
};

#endif // TREEPROXYMODEL_H
