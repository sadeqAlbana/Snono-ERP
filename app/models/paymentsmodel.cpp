#include "paymentsmodel.h"


PaymentsModel::PaymentsModel(QObject *parent) : AppNetworkedJsonModel("/payments",{
                                                 {"id",tr("ID")} ,
                                                 {"name",tr("Payment Method"),"payment_method"} ,
                                                 {"journal_entry_id",tr("Journal Entry")} ,
                                                 {"amount",tr("Amount"),QString(),false,"currency"} ,
                                                 {"status",tr("Status"),QString(),false,"PaymentStatusDelegate"},
                                                 {"date",tr("Date"),QString(),false,"datetime"},
                                                 {"created_at",tr("Created At"),QString(),false,"datetime"}

                                             },
                            parent)
{

}
