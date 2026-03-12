#include "vendorbillitemcategorymodel.h"

VendorBillItemCategoryModel::VendorBillItemCategoryModel(QObject *parent) : AppNetworkedJsonModel("/vendorBillItemCategories",{
                                            {"id",tr("ID")},
                                            {"name",tr("Name")},
                                            {"account_id",tr("Account")},

},
                            parent)
{

}
