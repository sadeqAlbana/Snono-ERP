#include "monthlyfinancemodel.h"


MonthlyFinanceModel::MonthlyFinanceModel(QObject *parent) : AppNetworkedJsonModel("/reports/monthlyFinance",{
                                               {"month",tr("Month")},
                                                           {"sales",tr("Sales"),QString(),false,"currency"} ,
                                                           {"sales_returns",tr("Sales Returns"),QString(),false,"currency"} ,
                                                           {"cost_of_goods_sold",tr("Cost of Goods Sold"),QString(),false,"currency"} ,
                                                           {"expenses",tr("Expenses"),QString(),false,"currency"} ,
                                                           {"gross_profit",tr("Gross Profit"),QString(),false,"currency"}


                                               },
                            parent)
{

}
