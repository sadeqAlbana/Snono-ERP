#include "orderitemsmodel.h"

OrderItemsModel::OrderItemsModel(const QJsonArray &data, QObject *parent) : JsonModel(data,{
                                                                                      Column{"name","Product","products"} ,
                                                                                      Column{"qty","Quantity"} ,
                                                                                      Column{"unit_price","Unit Price"} ,
                                                                                      Column{"subtotal","Subtotal"} ,
                                                                                      Column{"total","Total"}},parent)
{

}

