#include "paymentsmodel.h"


PaymentsModel::PaymentsModel(QObject *parent) : AppNetworkedJsonModel("/payments",{
                                                 {"id",tr("ID")} ,
                                                 {"name",tr("Payment Method"),"payment_method"} ,
                                                 {"journal_entry_id",tr("Journal Entry")} ,
                                                 {"date",tr("Date"),QString(),false},
                                                 {"created_at",tr("Created At"),QString(),false}

                                             },
                            parent)
{

}
