#include "journalentriesitemsmodel.h"

JournalEntriesItemsModel::JournalEntriesItemsModel(QObject *parent) : AppNetworkedJsonModel ("/journal/items",{

//Column{"id","ID"} ,
{"name",tr("Name")} ,
{"entry_id",tr("Entry ID")} ,
//{"account_id",tr("Account ID")} ,
{"name",tr("Account Name"),"accounts"} ,
{"internal_type",tr("Account Internal Type"),"accounts","internal_type"} ,
{"type",tr("Account Type"),"accounts","type"} ,
{"debit",tr("Debit"),QString(),"currency"} ,
{"credit",tr("Credit"),QString(),"currency"}}
//Column{"created_at","Date"}
,parent)
{
   
}
