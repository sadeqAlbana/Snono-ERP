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
