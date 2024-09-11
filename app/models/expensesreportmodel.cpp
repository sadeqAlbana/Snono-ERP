#include "expensesreportmodel.h"


ExpensesReportModel::ExpensesReportModel(QObject *parent) : AppNetworkedJsonModel("/reports/expenses",{
        JsonModelColumnList(),

                                                       },
                            parent)
{

}
