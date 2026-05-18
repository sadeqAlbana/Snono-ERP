#include "payrollrunsmodel.h"

PayrollRunsModel::PayrollRunsModel(QObject *parent) : AppNetworkedJsonModel("/payrollRuns",{
                                         {"id",tr("ID")} ,
                                         {"name",tr("Name")} ,
                                         {"period_start",tr("Period Start")} ,
                                         {"period_end",tr("Period End")} ,
                                         {"status",tr("Status")} ,
                                         {"total",tr("Total")} ,},parent)
{

}
