#include "vendorbillattributemodel.h"


VendorBillAttributeModel::VendorBillAttributeModel(QObject *parent) : AppNetworkedJsonModel("/vendorBillAttributes",{
                                         {"external_reference",tr("External Reference")} ,
                                         {"id",tr("Attribute")} ,
                                         {"value",tr("Value")} ,
                                         {"created_at",tr("Created At")}},parent)
{

}


