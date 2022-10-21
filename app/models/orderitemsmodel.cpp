#include "orderitemsmodel.h"

OrderItemsModel::OrderItemsModel(QObject *parent) :
    JsonModel(QJsonArray(),{
                                                                                      {"name",tr("Product"),"products"} ,
                                                                                      {"qty",tr("Quantity")} ,
                                                                                      {"unit_price",tr("Unit Price"),QString(),"currency"} ,
                                                                                      {"subtotal",tr("Subtotal"),QString(),"currency"} ,
                                                                                      {"total",tr("Total"),QString(),"currency"}},parent)
{

}

