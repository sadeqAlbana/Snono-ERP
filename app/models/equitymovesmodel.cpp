#include "equitymovesmodel.h"



EquityMovesModel::EquityMovesModel(QObject *parent) : AppNetworkedJsonModel("/equity/moves",{
                                             {"id",tr("ID")} ,
                                             {"name",tr("Owner"),"party"} ,
                                             {"journal_entry_id",tr("Journal Entry")} ,
                                              {"amount",tr("amount"),QString(),false,"currency"},
                                             {"date",tr("Date"),QString(),false,"datetime"},
                                             {"created_at",tr("Created At"),QString(),false,"datetime"}

                                         },
                            parent)
{

}
