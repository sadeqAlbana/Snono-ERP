#include "newjournalentrymodel.h"

NewJournalEntryModel::NewJournalEntryModel(QObject *parent)
    : JsonModel(QJsonArray(),
                JsonModelColumnList{
                                    {"no",tr("No")},
                    {"account_id",tr("Account"),QString(),false,"combo"},
                    {"description",tr("Description")},
                    {"debit",tr("Debit"),QString(),false,"number"},
                    {"credit",tr("Credit"),QString(),false,"number"}
                },
                parent)
{



}


Qt::ItemFlags NewJournalEntryModel::flags(const QModelIndex &index) const
{
    switch(index.column()){
    case 1:
    case 2:
    case 3:
    case 4: return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
    default: return JsonModel::flags(index);
    }
}

void NewJournalEntryModel::newEntry()
{
    QJsonObject record=this->record();

    record["no"]=rowCount()+1;
    record["account_id"]=3;

    appendRecord(record);
}
