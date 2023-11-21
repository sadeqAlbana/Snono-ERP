#include "ordersreturnsmodel.h"

OrdersReturnsModel::OrdersReturnsModel(QObject *parent) : AppNetworkedJsonModel("/orders/returns",{
//                                                                                {"name","Customer","customers"} ,
                                                                                {"reference",tr("Order Reference"),"order",false,

                                                 "link",
                                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/orders/OrderDetailsPage.qml"},
                                                             {"linkKey","order_id"}}} ,
                                                                                {"total",tr("Total"),QString(),false,"currency"} ,
                                                                                {"date",tr("Date"),QString(),false,"datetime"} ,
                                                                                {"tax_amount",tr("Tax Amount"),QString(),false,"currency"}
                                                                                },
                                                                                parent)
{
  
}
