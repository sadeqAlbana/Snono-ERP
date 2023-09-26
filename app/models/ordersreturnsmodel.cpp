#include "ordersreturnsmodel.h"

OrdersReturnsModel::OrdersReturnsModel(QObject *parent) : AppNetworkedJsonModel("/orders/returns",{
//                                                                                {"name","Customer","customers"} ,
                                                                                {"reference",tr("Order Reference"),"order",

                                                 "link",
                                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/orders/OrderDetailsPage.qml"},
                                                             {"linkKey","order_id"}}} ,
                                                                                {"total",tr("Total"),QString(),"currency"} ,
                                                                                {"date",tr("Date"),QString(),"datetime"} ,
                                                                                {"tax_amount",tr("Tax Amount"),QString(),"currency"}
                                                                                },
                                                                                parent)
{
  
}
