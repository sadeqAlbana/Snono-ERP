#include "newjournalentrymodel.h"

NewJournalEntryModel::NewJournalEntryModel(QObject *parent)
    : JsonModel(QJsonArray(),
                JsonModelColumnList{
                                    {"no",tr("No")},
                    {"account",tr("Account")},
                    {"description",tr("Description")},
                    {"debit",tr("Debit")},
                    {"credit",tr("Credit")}
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
