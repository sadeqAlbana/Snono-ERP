#include "journalentriesitemsmodel.h"

JournalEntriesItemsModel::JournalEntriesItemsModel(QObject *parent) : AppNetworkedJsonModel ("/journal/items",{

//Column{"id","ID"} ,
Column{"name",tr("Name")} ,
Column{"entry_id",tr("Entry ID")} ,
//Column{"account_id",tr("Account ID")} ,
Column{"name",tr("Account Name"),"accounts"} ,
Column{"internal_type",tr("Account Internal Type"),"accounts","internal_type"} ,
Column{"type",tr("Account Type"),"accounts","type"} ,
Column{"debit",tr("Debit"),QString(),"currency"} ,
Column{"credit",tr("Credit"),QString(),"currency"}}
//Column{"created_at","Date"}
,parent)
{
    requestData();
}
