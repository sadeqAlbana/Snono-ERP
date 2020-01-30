#include "cashiermodel.h"
#include <QMessageBox>
#include <QJsonArray>
#include <QJsonObject>
CashierModel::CashierModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_headerData << tr("No") << tr("barcode") << tr("Name") << tr("Price") << tr("qty") << tr("Total");
}

QVariant CashierModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Horizontal && role==Qt::DisplayRole)
        return m_headerData[section];

    return QVariant();
}




int CashierModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_data.count();
}

int CashierModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_headerData.count();
}

QVariant CashierModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if(index.row()<rowCount() && index.column() < columnCount())
    {
        if(role==Qt::DisplayRole || role==Qt::EditRole)
            return m_data[index.row()][index.column()];
    }

    return QVariant();
}

bool CashierModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        if(role==Qt::DisplayRole || role==Qt::EditRole)
        {
            m_data[index.row()][index.column()]=value;
            emit dataChanged(index, index, QVector<int>() << role);
            return true;
        }
    }
    return false;
}

Qt::ItemFlags CashierModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return index.column() == 4 ? Qt::ItemIsEditable | Qt::ItemIsEnabled | Qt::ItemIsSelectable :
                                                      Qt::ItemIsEnabled | Qt::ItemIsSelectable ;
}

bool CashierModel::insertRows(int row, int count, const QModelIndex &parent)
{

    beginInsertRows(parent, row, row + count - 1);
    for(int i=row ; i<count+row ; i++)
        m_data.insert(i,QVariantList() << QVariant() << QVariant() << QVariant() << QVariant() << QVariant() << QVariant());
    endInsertRows();
    return true;
}

bool CashierModel::insertColumns(int column, int count, const QModelIndex &parent)
{
    beginInsertColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endInsertColumns();
    return false;
}

bool CashierModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endRemoveRows();
    return false;
}

bool CashierModel::removeColumns(int column, int count, const QModelIndex &parent)
{
    beginRemoveColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endRemoveColumns();
    return false;
}

void CashierModel::addItem(int barcode)
{
    QModelIndexList list=match(index(0,1),Qt::DisplayRole,barcode,1,Qt::MatchWildcard);
    if(!list.isEmpty())
    {
        QModelIndex last=list.first();
        qlonglong price=last.sibling(last.row(),3).data().toString().toLongLong();
        QModelIndex qty= last.sibling(last.row(),4);
        QModelIndex _total= last.sibling(last.row(),5);
        setData(qty,qty.data().toInt()+1);
        setData(_total,_total.data().toString().toLongLong()+price);
        emit totalChanged(total());
    }
    else
    {
        manager.get(QString("/item/?barcode=%1").arg(barcode))->subcribe(this,&CashierModel::onItemDataRecieved);
    }

}

void CashierModel::reset()
{
    beginResetModel();
    m_data.clear();
    endResetModel();
    emit totalChanged(total());
}

QJsonArray CashierModel::items()
{
    if(rowCount())
    {
        QJsonArray items;
        for(int row=0; row<rowCount(); row++)
        {
            QJsonObject item;
            item.insert("barcode",index(row,1).data().toString().toInt());
            item.insert("qty",index(row,4).data().toFloat());
            items << item;
        }
        return items;
    }
    return QJsonArray();
}

qreal CashierModel::total()
{
    if(rowCount())
    {
        qreal _total=0;
        for(int i=0; i<rowCount(); i++)
        {
            _total+=index(i,5).data().toReal();
        }
        return _total;
    }
    return 0;
}

void CashierModel::onItemDataRecieved(NetworkResponse *res)
{
    if(res->json("valid").toBool())
    {
        qDebug().noquote()<<res->json();
        insertRow(rowCount());
        int row=rowCount()-1;
        setData(index(row,0),rowCount());
        setData(index(row,1),res->json("barcode").toInt());
        setData(index(row,2),res->json("name").toString());
        setData(index(row,3),res->json("sell_price").toDouble());
        setData(index(row,4),1);
        setData(index(row,5),res->json("sell_price").toDouble());
        emit totalChanged(total());
    }
    else
        QMessageBox::warning(static_cast<QWidget *>(parent()),tr("No such Item"),tr("Invalid Barcode !"),QMessageBox::Ok);
}
