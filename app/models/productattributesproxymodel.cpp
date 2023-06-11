
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
        case 2: return QStringLiteral("Action");

        default: return QVariant();

    }
}



QModelIndex ProductAttributesProxyModel::index(int row, int column, const QModelIndex &parent) const
{
    if(!sourceModel()){
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

    return 3;
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
        case 2: return QStringLiteral("action");
        default:
            break;
        }
    }

    return QAbstractProxyModel::data(index,role);
}

bool ProductAttributesProxyModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    qDebug()<<"Set data called: " << value;
    return QAbstractProxyModel::setData(index,value,role);
//    if (data(index, role) != value) {
//        // FIXME: Implement me!
//        emit dataChanged(index, index, {role});
//        return true;
//    }
//    return false;
}

Qt::ItemFlags ProductAttributesProxyModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return QAbstractProxyModel::flags(index) | Qt::ItemIsEditable; // FIXME: Implement me!
}

bool ProductAttributesProxyModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endInsertRows();
    return true;
}


bool ProductAttributesProxyModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endRemoveRows();
    return true;
}

QModelIndex ProductAttributesProxyModel::mapToSource(const QModelIndex &proxyIndex) const
{
    switch(proxyIndex.column()){
        case 0: return sourceModel()->index(proxyIndex.row(),m_keyColumn);
        case 1: return sourceModel()->index(proxyIndex.row(),m_valueColumn);
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

    return QModelIndex();
}

void ProductAttributesProxyModel::setSourceModel(QAbstractItemModel *sourceModel)
{
    if(sourceModel){
        for(int i=0; i<sourceModel->columnCount(); i++){
            QString header=sourceModel->headerData(i,Qt::Horizontal,Qt::EditRole).toString();
            if(header=="attribute_id"){
                m_keyColumn=i;
            }
            if(header=="value"){
                m_valueColumn=i;
            }
        }
    }

    QAbstractProxyModel::setSourceModel(sourceModel);
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


