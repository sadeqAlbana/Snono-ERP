#include "journalentriesmodel.h"

JournalEntriesModel::JournalEntriesModel(QObject *parent) : AppNetworkedJsonModel("/journal/entries",
                                                                ColumnList()<<Column{"id","ID"},
                                                                parent)
{

}
