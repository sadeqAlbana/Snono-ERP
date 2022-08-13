#include "checkablelistmodel.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
CheckableListModel::CheckableListModel(const QString &displayColumn,
                                       const QString &dataColumn,
                                       const QSet<int> original,
                                       const QString &url, QObject *parent):

    AppNetworkedJsonModel(url,
                           ColumnList() << Column{dataColumn,dataColumn}
                            << Column{displayColumn,displayColumn},

                           parent),
    displayColumn(displayColumn),
    dataColumn(dataColumn),
    m_originalSelectedIds(original)
{
    connect(this,&CheckableListModel::dataRecevied,this,&CheckableListModel::onDataRecevied);
}

Qt::ItemFlags CheckableListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return AppNetworkedJsonModel::flags(index) | Qt::ItemIsUserCheckable;
}

//ColumnList CheckableListModel::columns() const
//{
//    return ColumnList() << Column{displayColumn,displayColumn};
//}

QVariant CheckableListModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid()){
        return QVariant();
    }

//    qDebug()<<"data: " <<index<< " " << (role==Qt::CheckStateRole);
    if(role==Qt::CheckStateRole){

        if(m_selected.contains(index.row()))
            return Qt::Checked;
        return Qt::Unchecked;
    }

    return AppNetworkedJsonModel::data(index,role);
}

bool CheckableListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!index.isValid())
        return false;

    if(role==Qt::CheckStateRole){
        int state=value.toInt();
        if(data(index,role).toInt()==state)
            return true;
        if(state==Qt::Checked)
            m_selected.insert(index.row());
        else if(state==Qt::Unchecked)
            m_selected.remove(index.row());
        emit dataChanged(index, index, QVector<int>() << role); //not sure about index !
        emit selectedItemsChanged();

        return true;
    }
    return AppNetworkedJsonModel::setData(index,value,role);
}

QJsonArray CheckableListModel::selectedRows()
{
    QJsonArray array;
    for(int row : m_selected){
        array <<  jsonObject(row);
    }
    return array;
}

QString CheckableListModel::selectedItems() const
{
    QStringList items;
    for(int row : m_selected){
        items << AppNetworkedJsonModel::data(row,displayColumn).toString();
    }
    return items.join(", ");
}

QList<int> CheckableListModel::selectedIds()
{
    return m_selected.values();
}

void CheckableListModel::setSelected(const QSet<int> &ids)
{
    for(int i=0; i < rowCount(); i++){
        int id = AppNetworkedJsonModel::jsonObject(i).value(dataColumn).toInt();
        if(ids.contains(id))
           setData(index(i,0),Qt::Checked,Qt::CheckStateRole);
    }
}

void CheckableListModel::setCheckStateForAll(Qt::CheckState checkstate)
{
    for(int i=0; i < rowCount(); i++){
           setData(index(i,0),checkstate,Qt::CheckStateRole);
    }
}

void CheckableListModel::uncheckAll()
{
    setCheckStateForAll(Qt::Unchecked);
}

QHash<int, QByteArray> CheckableListModel::roleNames() const
{
    QHash<int,QByteArray> roles=AppNetworkedJsonModel::roleNames();

    roles.insert(Qt::CheckStateRole,"checkstate");

    return roles;
}

void CheckableListModel::onDataRecevied()
{
    setSelected(m_originalSelectedIds);
}


