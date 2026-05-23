#include "invoicesmodel.h"



InvoicesModel::InvoicesModel(QObject *parent) : AppNetworkedJsonModel("/invoices",{
                                             {"id",tr("ID")} ,
                                             {"name",tr("Name")} ,
                                             {"status",tr("Status"),QString(),false,"InvoiceStatus"} ,
                                             {"date",tr("Date"),QString(),false,"datetime"},
                                             {"due_date",tr("Due Date"),QString(),false,"datetime"},
                                             {"balance_due",tr("Balance Due"),QString(),false,"currency"},
                                             {"total",tr("Total"),QString(),false,"currency"},
                                             {"created_at",tr("Created At"),QString(),false,"datetime"}

                                         },
                            parent)
{

}
