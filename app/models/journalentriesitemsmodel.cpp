#include "journalentriesitemsmodel.h"

JournalEntriesItemsModel::JournalEntriesItemsModel(QObject *parent) : AppNetworkedJsonModel ("/journal/items",{

//Column{"id","ID"} ,
{"name",tr("Name")} ,
 {"entry_id",tr("Entry ID"),QString(),"link",
 QVariantMap{{"link","qrc:/PosFe/qml/pages/Accounting/JournalEntryDetailsPage.qml"},{"linkKey","entry_id"}}},
//{"account_id",tr("Account ID")} ,
{"name",tr("Account Name"),"account"} ,
{"internal_type",tr("Account Internal Type"),"account","internal_type"} ,
{"type",tr("Account Type"),"account","type"} ,
{"debit",tr("Debit"),QString(),"currency"} ,
{"credit",tr("Credit"),QString(),"currency"}}
//Column{"created_at","Date"}
,parent)
{
   
}
