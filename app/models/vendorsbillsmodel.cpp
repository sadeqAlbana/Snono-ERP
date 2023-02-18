#include "vendorsbillsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include "networkresponse.h"

VendorsBillsModel::VendorsBillsModel(QObject *parent) : AppNetworkedJsonModel("/vendors/bills",{
                                                                                             {"id",tr("ID")} ,
                                                                                             {"name",tr("Name")} ,
                                                                                             {"reference",tr("Reference")} ,
                                                                                             {"external_reference",tr("External Reference")} ,
                                                                                             {"date",tr("Date"),QString(),"datetime"} ,
                                                                                             {"due_date",tr("Due Date"),QString(),"datetime"} ,
                                                                                             {"total",tr("Total"),QString(),"currency"} ,
                                                                                             {"status",tr("Status"),QString(),"status"}}
                                                                                                               ,parent)
{
    requestData();
}



void VendorsBillsModel::payBill(const int &vendorBillId)
{
    PosNetworkManager::instance()->post(QUrl("/vendors/bills/pay"),QJsonObject{{"billId",vendorBillId}})

            ->subscribe([this](NetworkResponse *res){

        emit payBillReply(res->json().toObject());
    });
}

void VendorsBillsModel::createBill(const int &vendorId, const QJsonArray &products)
{
    QJsonObject params;
    params["products"]=products;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post(QUrl("/products/purchaseProduct"),params)->subscribe(
                [this](NetworkResponse *res){
        emit createBillReply(res->json().toObject());
    });
}
