#include "paymentrefundsmodel.h"


PaymentRefundsModel::PaymentRefundsModel(QObject *parent) : AppNetworkedJsonModel("/paymentRefunds",{
                                             {"id",tr("ID")} ,
                                             {"name",tr("Refund Method"),"payment_method"} ,
                                             {"journal_entry_id",tr("Journal Entry")} ,
                                            {"status",tr("Status")},
                                             {"date",tr("Date"),QString(),false},
                                             {"created_at",tr("Created At"),QString(),false}

                                         },
                            parent)
{

}
