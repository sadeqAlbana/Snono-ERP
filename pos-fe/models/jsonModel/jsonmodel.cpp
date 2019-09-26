#include "jsonmodel.h"
#include <QDebug>
JsonModel::JsonModel(QObject *parent) : QAbstractTableModel(parent)
{

}

JsonModel::JsonModel(QJsonArray data, QObject *parent) : QAbstractTableModel(parent)
{

    setupData(data);

}

JsonModel::~JsonModel()
{

}

QVariant JsonModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return orientation==Qt::Horizontal && role==Qt::DisplayRole ?
                m_record.fieldName(section) :
                QVariant();
}

/*bool JsonModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    if (value != headerData(section, orientation, role)) {
        // FIXME: Implement me!
        emit headerDataChanged(orientation, section, section);
        //return true;
        return false;
    }
    return false;


}*/


int JsonModel::rowCount(const QModelIndex &parent) const
{
    return m_records.count();
}

int JsonModel::columnCount(const QModelIndex &parent) const
{
    return record().count();
}

QVariant JsonModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if(index.row() >= rowCount() || index.column() >= record().count())
        return QVariant();

    if(role==Qt::DisplayRole || role==Qt::EditRole )
        return m_records.at(index.row()).value(index.column());


    return QVariant();
}

bool JsonModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        m_records[index.row()].setValue(index.column(),value);
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags JsonModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    //return Qt::ItemIsEditable // FIXME: Implement me!

    return Qt::ItemIsEnabled | Qt::ItemIsSelectable;
}

/*bool JsonModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endInsertRows();
}*/

/*bool JsonModel::insertColumns(int column, int count, const QModelIndex &parent)
{
    beginInsertColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endInsertColumns();
}*/

/*bool JsonModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    // FIXME: Implement me senpai!
    endRemoveRows();
}*/

/*bool JsonModel::removeColumns(int column, int count, const QModelIndex &parent)
{
    beginRemoveColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endRemoveColumns();
}*/

JsonModelRecord JsonModel::record() const
{
    return m_record;
}

void JsonModel::insertData(QJsonArray data)
{
    setupData(data);
}

void JsonModel::setupData(QJsonArray &data)
{
    beginResetModel();
    m_record.clear(); // will cause memory leak if you don't clear the fields too !
    m_records.clear();
    for(QJsonValue row : data)
    {
        m_records << JsonModelRecord(row.toObject());
    }

    QJsonObject obj=data.at(0).toObject();

    for(QString key: obj.keys())
        obj.insert(key,QJsonValue());

    m_record=obj;

    endResetModel();
}
