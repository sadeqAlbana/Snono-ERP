#include "orderitemsmodel.h"

OrderItemsModel::OrderItemsModel(QObject *parent) :
    JsonModel(QJsonArray(),{
                                                                                      Column{"name",tr("Product"),"products"} ,
                                                                                      Column{"qty",tr("Quantity")} ,
                                                                                      Column{"unit_price",tr("Unit Price"),QString(),"currency"} ,
                                                                                      Column{"subtotal",tr("Subtotal"),QString(),"currency"} ,
                                                                                      Column{"total",tr("Total"),QString(),"currency"}},parent)
{

}

