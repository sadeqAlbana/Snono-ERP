#include "vendorsbillsmodel.h"
#include "posnetworkmanager.h"
#include <QJsonObject>
VendorsBillsModel::VendorsBillsModel(QObject *parent) : AppNetworkedJsonModel("/vendors/bills",{
                                                                                             Column{"id","ID"} ,
                                                                                             Column{"name"," Name"} ,
                                                                                             Column{"reference","Reference"} ,
                                                                                             Column{"external_reference","External Reference"} ,
                                                                                             Column{"date","Date",QString(),"datetime"} ,
                                                                                             Column{"due_date","Due Date",QString(),"datetime"} ,
                                                                                             Column{"total","Total",QString(),"currency"} ,
                                                                                             Column{"status","Status",QString(),"status"}}
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

void VendorsBillsModel::createBill(const int &vendorId, const QJsonArray &products)
{
    QJsonObject params;
    params["products"]=products;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post("/products/purchaseProduct",params)->subcribe(
                [this](NetworkResponse *res){
        emit createBillReply(res->json().toObject());
    });
}
