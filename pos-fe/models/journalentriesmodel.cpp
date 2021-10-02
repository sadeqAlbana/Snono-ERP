#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                ColumnList()<<Column{"id","ID"} <<
                                                                              Column{"name","Name"} <<
                                                                              Column{"reference","Reference"} <<
                                                                              Column{"posted","Posted"} <<
                                                                              Column{"posted_date","Posted Date"} <<

                                                                              Column{"date","Date"} <<
                                                                              Column{"amount_toal","Total",QString(),"currency"}
                                                                              ,
                                                                parent)
{
    requestData();
}
