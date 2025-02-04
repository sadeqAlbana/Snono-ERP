#include "invoicesmodel.h"



InvoicesModel::InvoicesModel(QObject *parent) : AppNetworkedJsonModel("/payments",{
                                             {"id",tr("ID")} ,
                                             {"name",tr("Name")} ,
                                             {"status",tr("Status")} ,
                                             {"date",tr("Date"),QString(),false},
                                             {"due_date",tr("Due Date"),QString(),false},
                                             {"balance_due",tr("Balance Due"),QString(),false},
                                             {"Total",tr("Total"),QString(),false},
                                             {"created_at",tr("Created At"),QString(),false}

                                         },
                            parent)
{

}
