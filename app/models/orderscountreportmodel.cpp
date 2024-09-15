#include "orderscountreportmodel.h"


OrdersCountReportModel::OrdersCountReportModel(QObject *parent) : AppNetworkedJsonModel("/reports/ordersCount",{
                                              {"dt",tr("Date")} ,
                                              {"count",tr("Orders Count")}
                                                    },
                            parent)
{

}
