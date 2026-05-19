#include "payrollrunsmodel.h"

PayrollRunsModel::PayrollRunsModel(QObject *parent) : AppNetworkedJsonModel("/payrollRuns",{
                                         {"id",tr("ID")} ,
                                         {"name",tr("Name")} ,
                                         {"period_start",tr("Period Start"),QString(),false,"date"} ,
                                         {"period_end",tr("Period End"),QString(),false,"date"} ,
                                         {"status",tr("Status")} ,
                                         {"total",tr("Total"),QString(),false,"currency"} ,},parent)
{

}
