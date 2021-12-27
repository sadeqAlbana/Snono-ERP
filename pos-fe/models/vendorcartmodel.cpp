#include "vendorcartmodel.h"

VendorCartModel::VendorCartModel(QObject *parent) : JsonModel(QJsonArray(),{
                                                              Column{"product_id","ID"},
                                                              Column{"cost","Cost"},
                                                              Column{"qty","Qty"}
                                                              }
                                                              ,parent)
{

}
