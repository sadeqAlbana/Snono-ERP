
#include "productattributesproxymodel.h"


ProductAttributesProxyModel::ProductAttributesProxyModel(QObject *parent)
    : QAbstractProxyModel(parent)
{

}

QVariant ProductAttributesProxyModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical){
        return QVariant();
    }


    switch(section){
        case 0: return QStringLiteral("Attribute");
        case 1: return QStringLiteral("Value");
        case 2: return QStringLiteral("Type");

        case 3: return QStringLiteral("Action");

        default: return QVariant();

    }
}



QModelIndex ProductAttributesProxyModel::index(int row, int column, const QModelIndex &parent) const
{
    if(!sourceModel() || parent.isValid()){
        return QModelIndex();
    }

    return createIndex(row,column);
}



int ProductAttributesProxyModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid() || !sourceModel())
        return 0;

    return sourceModel()->rowCount();
}

int ProductAttributesProxyModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid() || !sourceModel())
        return 0;

    return 4;
}

bool ProductAttributesProxyModel::hasChildren(const QModelIndex &parent) const
{
    return false;
}




QVariant ProductAttributesProxyModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || index.row()>=rowCount() || index.column()>=columnCount())
        return QVariant();


    if(role==Qt::UserRole){
        switch (index.column()) {
        case 0:
        case 1: return QStringLiteral("text");
        case 2: return QStringLiteral("combo");
        case 3: return QStringLiteral("action");
        default:
            break;
        }
    }

    return QAbstractProxyModel::data(index,role);
}

bool ProductAttributesProxyModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        if(QAbstractProxyModel::setData(index,value,role)){
            emit dataChanged(index, index, {role});
            return true;
        }
    }
    return false;
}

Qt::ItemFlags ProductAttributesProxyModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return QAbstractProxyModel::flags(index) | Qt::ItemIsEditable; // FIXME: Implement me!
}



QModelIndex ProductAttributesProxyModel::mapToSource(const QModelIndex &proxyIndex) const
{
    switch(proxyIndex.column()){
        case 0: return sourceModel()->index(proxyIndex.row(),m_keyColumn);
        case 1: return sourceModel()->index(proxyIndex.row(),m_valueColumn);
        case 2: return sourceModel()->index(proxyIndex.row(),2);

        default: return QModelIndex();

    }
}

QModelIndex ProductAttributesProxyModel::mapFromSource(const QModelIndex &sourceIndex) const
{

    if(sourceIndex.column()==m_keyColumn){
         return index(sourceIndex.row(),0);
    }

    if(sourceIndex.column()==m_valueColumn){
         return index(sourceIndex.row(),1);
    }

    if(sourceIndex.column()==2){
         return index(sourceIndex.row(),2);
    }

    return QModelIndex();
}

void ProductAttributesProxyModel::setSourceModel(QAbstractItemModel *sourceModel)
{
    if(!sourceModel){
         return;
    }



    QAbstractProxyModel::setSourceModel(sourceModel);

    connect(sourceModel,&QAbstractItemModel::rowsAboutToBeInserted,this,&ProductAttributesProxyModel::beginInsertRows);
    connect(sourceModel,&QAbstractItemModel::rowsInserted,this,&ProductAttributesProxyModel::endInsertRows);

    connect(sourceModel,&QAbstractItemModel::rowsInserted,this,&ProductAttributesProxyModel::rowsInserted);

    connect(sourceModel,&QAbstractItemModel::rowsAboutToBeRemoved,this,&ProductAttributesProxyModel::beginRemoveRows);
    connect(sourceModel,&QAbstractItemModel::rowsRemoved,this,&ProductAttributesProxyModel::endRemoveRows);



}

QModelIndex ProductAttributesProxyModel::parent(const QModelIndex &child) const
{
    return QModelIndex();
}

QHash<int, QByteArray> ProductAttributesProxyModel::roleNames() const
{
    QHash<int,QByteArray> roles=sourceModel()->roleNames();
    roles.insert(Qt::UserRole,"delegateType");

    return roles;
}


