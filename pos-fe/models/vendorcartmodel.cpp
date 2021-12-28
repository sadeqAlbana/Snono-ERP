#include "vendorcartmodel.h"

VendorCartModel::VendorCartModel(QObject *parent) : JsonModel(QJsonArray(),{
                                                              Column{"product_id","ID"},
                                                              Column{"cost","Cost"},
                                                              Column{"name","Name"},
                                                              Column{"qty","Qty"},
                                                              Column{"sku","SKU"},
                                                              Column{"thumb","Thumb"}
                                                              }
                                                              ,parent)
{

}
