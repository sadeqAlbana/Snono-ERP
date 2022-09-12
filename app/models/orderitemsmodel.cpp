#include "orderitemsmodel.h"

OrderItemsModel::OrderItemsModel(const QJsonArray &data, QObject *parent) :
    JsonModel(data,{
                                                                                      Column{"name",tr("Product"),"products"} ,
                                                                                      Column{"qty",tr("Quantity")} ,
                                                                                      Column{"unit_price",tr("Unit Price"),QString(),"currency"} ,
                                                                                      Column{"subtotal",tr("Subtotal"),QString(),"currency"} ,
                                                                                      Column{"total",tr("Total"),QString(),"currency"}},parent)
{

}

