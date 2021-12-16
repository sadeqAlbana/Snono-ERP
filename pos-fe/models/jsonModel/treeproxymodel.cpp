#include "treeproxymodel.h"
#include "../categoriesmodel.h"
#include <QTimer>
#include <QDebug>
TreeProxyModel::TreeProxyModel(QObject *parent)
    : QAbstractProxyModel(parent)
{
    mdl = new CategoriesModel();
//    setSourceModel(mdl);
    QTimer::singleShot(1000,[this](){
        qDebug()<<"setting model";
       this->setSourceModel(this->mdl);
    });
}


QModelIndex TreeProxyModel::mapFromSource(const QModelIndex &sourceIndex) const
{
    if(!sourceIndex.isValid())
        return QModelIndex();

#if QT_VERSION >= 0x50B000
    int id = (sourceIndex.column() == IDColumn) ? sourceIndex.data().toInt() : sourceIndex.siblingAtColumn(IDColumn).data().toInt();
#else
    int id = (sourceIndex.column() == IDColumn) ? sourceIndex.data().toInt() : sourceIndex.sibling(sourceIndex.row(),IDColumn).data().toInt();
#endif
    int row=childNumber(id);
    return createIndex(row, sourceIndex.column(), id);
}

QModelIndex TreeProxyModel::mapToSource(const QModelIndex &proxyIndex) const
{
    if(!proxyIndex.isValid())
        return QModelIndex();

    int id = proxyIndex.internalId();

    for(int i=0 ; i<sourceModel()->rowCount() ; i++)
        if(sourceModel()->index(i,IDColumn).data().toInt()==id)
            return sourceModel()->index(i, proxyIndex.column());

    return QModelIndex();
}



QModelIndex TreeProxyModel::parent(const QModelIndex &child) const
{
    if (!child.isValid())
        return QModelIndex();

    int childId  = child.internalId();
    int parentId = getParentId(childId);
    if(parentId == 0)
        return QModelIndex();
    int parentRow =childNumber(parentId);
    return createIndex(parentRow, child.row(), parentId);
}

QModelIndex TreeProxyModel::index(int row, int column, const QModelIndex &parent) const
{
    if(row < 0 || column < 0)
        return QModelIndex();

    int id=GetID(parent.internalId(),row);
    return createIndex(row, column, id);
}

int TreeProxyModel::rowCount(const QModelIndex &parent) const
{
    int ID=0;
    if(parent.isValid())
        ID=parent.internalId();

    int count=0;
    for(int i=0 ; i<sourceModel()->rowCount() ; i++)
        if(sourceModel()->index(i,pIDColumn).data().toInt()==ID)
            count++;

    qDebug()<<"parent: " << parent.internalId() << " " <<"Row count: " << " " << count;
    return count;
}

int TreeProxyModel::columnCount(const QModelIndex &parent) const
{
    return sourceModel()->columnCount();
}

int TreeProxyModel::getParentId(int childId) const
{
    for(int i=0; i<sourceModel()->rowCount() ; i++)
        if(sourceModel()->index(i,IDColumn).data().toInt()==childId)
            return sourceModel()->index(i,pIDColumn).data().toInt();

    return -1; //remove
}


int TreeProxyModel::childNumber(int ID) const
{
    int ParentID=getParentId(ID);
    int n=-1;
    for(int i=0 ; i<sourceModel()->rowCount() ; i++)
    {
        if(sourceModel()->index(i,pIDColumn).data().toInt()==ParentID)
        {
            n++;
            if(sourceModel()->index(i,IDColumn).data().toInt()==ID)
                return n;
        }
    }
    return -1;
}

int TreeProxyModel::GetID(int ParentID,int row) const
{
    int count=-1;
    for(int i=0 ; i<sourceModel()->rowCount() ; i++)
    {
        if(sourceModel()->index(i,pIDColumn).data().toInt()==ParentID)
            count++;
        if (count==row)
            return sourceModel()->index(i,IDColumn).data().toInt();
    }
    return -1; //remove this
}



Qt::ItemFlags TreeProxyModel::flags(const QModelIndex &index) const
{
    if(index.isValid())
    {
        return (Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemIsEditable);
    }

        return Qt::NoItemFlags;
}




int TreeProxyModel::level(QModelIndex index)
{
   QModelIndex Parent=index.parent();
    int lvl=1;

    while(Parent.isValid())
    {
        lvl++;
        Parent=Parent.parent();
    }
    return lvl;
}



bool TreeProxyModel::hasChildren(const int ParentID) const
{
    for(int i=0; i<sourceModel()->rowCount() ; i++)
        if(sourceModel()->index(i,pIDColumn).data().toInt()==ParentID)
            return true;

    return false;
}
