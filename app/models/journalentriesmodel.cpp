#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                                 {{"id",tr("ID")},
                                                                                  {"name",tr("Name")},
                                                                                  {"reference",tr("Reference")},
                                                                                  {"posted",tr("Posted")},
                                                                                  {"posted_date",tr("Posted Date"),QString(),false,"datetime"},
                                                                                  {"date",tr("Date"),QString(),false,"datetime"} ,
                                                                                  {"amount_total",tr("Total"),QString(),false,"currency"}},
                                                                                  parent)
{
   
}
