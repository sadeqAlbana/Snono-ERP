#ifndef JSONMODEL_H
#define JSONMODEL_H

#include <QAbstractTableModel>
#include <models/jsonModel/jsonmodelrecord.h>
#include <QJsonArray>
#include <QJsonObject>
class JsonModel : public QAbstractTableModel
{
    Q_OBJECT
public:    
    explicit JsonModel(QObject *parent = nullptr);
    explicit JsonModel(QJsonArray data, QObject *parent = nullptr);
    // Header:
    ~JsonModel();
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    //bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Add data:
    //bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    //bool insertColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

    // Remove data:
    //bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    //bool removeColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

    JsonModelRecord record() const;
    JsonModelRecord record(int index) const{return m_records.at(index);}

    void insertData(QJsonArray data);

    void setupData(QJsonArray &data);


protected:
    QVector<JsonModelRecord> m_records;
    JsonModelRecord m_record;
};

#endif // JSONMODEL_H
