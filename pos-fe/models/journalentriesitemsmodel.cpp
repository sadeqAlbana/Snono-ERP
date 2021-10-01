#include "journalentriesitemsmodel.h"

JournalEntriesItemsModel::JournalEntriesItemsModel(QObject *parent) : AppNetworkedJsonModel ("/journal/items",ColumnList() <<

//Column{"id","ID"} <<
Column{"name","Name"} <<
Column{"entry_id","Entry ID"} <<
//Column{"account_id","Account ID"} <<
Column{"name","Account Name","accounts"} <<
Column{"internal_type","Account Internal Type","accounts","internal_type"} <<
Column{"type","Account Type","accounts","type"} <<
Column{"debit","Debit",QString(),"currency"} <<
Column{"credit","Credit",QString(),"currency"}
//Column{"created_at","Date"}
,parent)
{
    requestData();
}
