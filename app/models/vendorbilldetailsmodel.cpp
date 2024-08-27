#include "vendorbilldetailsmodel.h"
#include "authmanager.h"
VendorBillDetailsModel::VendorBillDetailsModel(QObject *parent)
    : JsonModel{parent}
{


    JsonModelColumnList list{
                             {"id",tr("ID")} ,
                             {"name",tr("Product"),"product",false,
                                 "link",
                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/products/ProductForm.qml"},
                                             {"linkKey","product_id"}}
                             } ,{"unit_price",tr("Unit Price"),QString(),false,"currency"},

                             {"qty",tr("Quantity")} ,
                             {"total",tr("Total"),QString(),false,"currency"}
        };




    if(!AuthManager::instance()->hasPermission("prm_view_product_cost")){
        list.removeAt(4);
        list.removeAt(2);

    }
    m_columns=list;


}
