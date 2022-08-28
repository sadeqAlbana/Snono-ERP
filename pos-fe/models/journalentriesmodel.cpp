#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                                 {Column{"id","ID"},
                                                                                  Column{"name","Name"},
                                                                                  Column{"reference","Reference"},
                                                                                  Column{"posted","Posted"},
                                                                                  Column{"posted_date","Posted Date",QString(),"datetime"},
                                                                                  Column{"date","Date",QString(),"datetime"} ,
                                                                                  Column{"amount_total","Total",QString(),"currency"}},
                                                                                  parent)
{
    requestData();
}
