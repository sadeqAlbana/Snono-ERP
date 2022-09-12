#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                                 {Column{"id",tr("ID")},
                                                                                  Column{"name",tr("Name")},
                                                                                  Column{"reference",tr("Reference")},
                                                                                  Column{"posted",tr("Posted")},
                                                                                  Column{"posted_date",tr("Posted Date"),QString(),"datetime"},
                                                                                  Column{"date",tr("Date"),QString(),"datetime"} ,
                                                                                  Column{"amount_total",tr("Total"),QString(),"currency"}},
                                                                                  parent)
{
    requestData();
}
