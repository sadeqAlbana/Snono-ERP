#include "expensesreportmodel.h"


ExpensesReportModel::ExpensesReportModel(QObject *parent) : AppNetworkedJsonModel("/reports/expenses",{
                                                     {"name",tr("account"),QString(),false,"text"} ,
                                                     {"amount",tr("amount"),QString(),false,"currency"}

                                                       },
                            parent)
{

}
