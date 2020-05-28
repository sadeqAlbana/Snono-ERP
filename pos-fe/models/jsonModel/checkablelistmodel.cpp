#include "checkablelistmodel.h"

CheckableListModel::CheckableListModel(const QString &displayColumn, const QString &dataColumn, const QSet<int> original, const QString &url, QObject *parent):
    NetworkedJsonModel (url,parent),displayColumn(displayColumn),dataColumn(dataColumn),originalSelectedIds(original)
{
    connect(this,&CheckableListModel::dataRecevied,this,&CheckableListModel::onDataRecevied);
}

Qt::ItemFlags CheckableListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return NetworkedJsonModel::flags(index) | Qt::ItemIsUserCheckable;
}

ColumnList CheckableListModel::columns() const
{
    return ColumnList() << Column{displayColumn,displayColumn};
}

QVariant CheckableListModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid()){
        return QVariant();
    }
    if(role==Qt::CheckStateRole){
        if(selected.contains(index.row()))
            return Qt::Checked;
        return Qt::Unchecked;
    }

    return NetworkedJsonModel::data(index,role);
}

bool CheckableListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!index.isValid())
        return false;

    if(role==Qt::CheckStateRole){
        int state=value.toInt();
        if(state==Qt::Checked)
            selected.insert(index.row());
        else if(state==Qt::Unchecked)
            selected.remove(index.row());
        emit dataChanged(index, index, QVector<int>() << role); //not sure about index !
        return true;
    }
    return NetworkedJsonModel::setData(index,value,role);
}

QJsonArray CheckableListModel::selectedRows()
{
    QJsonArray array;
    for(auto row : selected){
        array <<  JsonModel::data(row);
    }
    return array;
}

void CheckableListModel::onDataRecevied()
{
    for(int i=0; i < rowCount(); i++){
        int id = JsonModel::data(i).value(dataColumn).toInt();
        if(originalSelectedIds.contains(id))
           setData(index(i,0),Qt::Checked,Qt::CheckStateRole);
    }
}


