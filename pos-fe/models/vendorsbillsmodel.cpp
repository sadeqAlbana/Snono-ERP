#include "vendorsbillsmodel.h"
#include "posnetworkmanager.h"
#include <QJsonObject>
VendorsBillsModel::VendorsBillsModel(QObject *parent) : AppNetworkedJsonModel("/vendors/bills",ColumnList() <<
                                                                                             Column{"id","ID"} <<
                                                                                             Column{"name"," Name"} <<
                                                                                             Column{"reference","Reference"} <<
                                                                                             Column{"external_reference","External Reference"} <<
                                                                                             Column{"date","Date"} <<
                                                                                             Column{"due_date","Due Date"} <<
                                                                                             Column{"amount_total","Amount","journal_entries","currency"} <<
                                                                                             Column{"status","Status",QString(),"status"}
                                                                                                               ,parent)
{
    requestData();
}



void VendorsBillsModel::payBill(const int &vendorBillId)
{
    PosNetworkManager::instance()->post("/vendors/bills/pay",QJsonObject{{"billId",vendorBillId}})

            ->subcribe([this](NetworkResponse *res){

        emit payBillReply(res->json().toObject());
    });
}
