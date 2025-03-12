#include "stockreservationsmodel.h"


StockReservationsModel::StockReservationsModel(QObject *parent)
    : AppNetworkedJsonModel{"/stockReservations",{
                                                      {"order_id",tr("Order"),QString(),false,"link",
                                                       QVariantMap{{"link","qrc:/PosFe/qml/pages/orders/OrderDetailsPage.qml"},
                                                                   {"linkKey","order_id"}}},
                                                    {"name",tr("Product"),"product",false,"link",
                                                     QVariantMap{{"link","qrc:/PosFe/qml/pages/products/ProductForm.qml"},
                                                                 {"linkKey","product_id"}}},
                                                    {"qty",tr("Qty")},
                                                    {"status",tr("Status"),QString(),false,"ReservationStatus"} ,
                                                    {"created_at",tr("Date")}


                                                },


                            parent}
{

}
