#include "orderitemsmodel.h"

OrderItemsModel::OrderItemsModel(const QJsonArray &data, QObject *parent) : JsonModel(data,{
                                                                                      Column{"name","Product","products"} ,
                                                                                      Column{"qty","Quantity"} ,
                                                                                      Column{"unit_price","Unit Price",QString(),"currency"} ,
                                                                                      Column{"subtotal","Subtotal",QString(),"currency"} ,
                                                                                      Column{"total","Total",QString(),"currency"}},parent)
{

}

