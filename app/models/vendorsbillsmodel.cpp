#include "vendorsbillsmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonObject>
#include "networkresponse.h"

VendorsBillsModel::VendorsBillsModel(QObject *parent) : AppNetworkedJsonModel("/vendorBills",{
                                                                                             {"id",tr("ID")} ,
                                                                                             {"name",tr("Name")} ,
                                             {"reference",tr("Reference")},

                                                                                             {"name",tr("Vendor"),"vendor",false,

                                                 "link",
                                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/vendors/VendorForm.qml"},
                                                             {"linkKey","vendor_id"}}
                                                                                       } ,
                                                                                             {"external_reference",tr("External Reference")} ,
                                                                                             {"date",tr("Date"),QString(),false,"datetime"} ,
                                                                                             {"due_date",tr("Due Date"),QString(),false,"datetime"} ,
                                                                                             {"total",tr("Total"),QString(),false,"currency"} ,
                                             {"payment_type",tr("Payment Method")} ,

                                                                                             {"status",tr("Status"),QString(),false,"status"}}
                                                                                                               ,parent)
{

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
