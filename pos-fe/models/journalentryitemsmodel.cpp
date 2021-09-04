#include "journalentryitemsmodel.h"

JournalEntryItemsModel::JournalEntryItemsModel(QObject *parent) : AppNetworkedJsonModel ("/journal/items",ColumnList() <<
                                                                                          Column{"id","ID"} <<
                                                                                          Column{"name","Name"} <<
                                                                                          Column{"entry_id","Entry ID"} <<
                                                                                          Column{"account_id","Account ID"} <<
                                                                                          Column{"name","Account Name","accounts"} <<
                                                                                          Column{"debit","Debit"} <<
                                                                                          Column{"credit","Credit"} <<
                                                                                          Column{"created_at","Date"},parent)
{
    //requestData();
}



