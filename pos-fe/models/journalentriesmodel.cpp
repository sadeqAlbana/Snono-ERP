#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                                 {Column{"id","ID"},
                                                                                  Column{"name","Name"},
                                                                                  Column{"reference","Reference"},
                                                                                  Column{"posted","Posted"},
                                                                                  Column{"posted_date","Posted Date"},
                                                                                  Column{"date","Date"} ,
                                                                                  Column{"amount_total","Total",QString(),"currency"}},
                                                                                  parent)
{
    requestData();
}
