#include "journalentryitemsmodel.h"

JournalEntryItemsModel::JournalEntryItemsModel(QObject *parent) : NetworkedJsonModel ("/journal/items",parent)
{
    requestData();
}

ColumnList JournalEntryItemsModel::columns() const
{
    return ColumnList() <<
                           Column{"id","ID"} <<
                           Column{"name","Name"} <<
                           Column{"entry_id","Entry ID"} <<
                           Column{"account_id","Account ID"} <<
                           Column{"name","Account Name","accounts"} <<
                           Column{"amount","Amount"} <<
                           Column{"type","Type"}<<
                           Column{"created_at","Date"};
}

QVariant JournalEntryItemsModel::data(const QModelIndex &index, int role) const
{
    QVariant data= NetworkedJsonModel::data(index,role);
    if(data.isValid() && role==Qt::DisplayRole && headerData(index.column(),Qt::Horizontal)=="Type"){
        int type=data.toInt();
        switch (type) {
            case 1: return QString("Debit");
            case 2: return QString("Credit");
            default: return QString("Invalid");
        }
    }

    return data;
}
