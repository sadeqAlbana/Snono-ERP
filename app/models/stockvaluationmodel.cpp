#include "stockvaluationmodel.h"

StockValuationModel::StockValuationModel(QObject *parent)
    : AppNetworkedJsonModel{"/stock/valuation",{
                                                {"description",tr("Description")},
                                                 {"name",tr("Product"),"product",false,"link",
                                                  QVariantMap{{"link","qrc:/PosFe/qml/pages/products/ProductForm.qml"},
                                                              {"linkKey","product_id"}}},
                                                {"qty",tr("Qty")},
                                                 {"cost",tr("Value")},
                                                {"total",tr("Total")},
                                                {"created_at",tr("Date")},
                                                 {"journal_entry_id",tr("Journal Entry")},
                                                 {"order_id",tr("Order"),QString(),false,"link",
                                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/orders/OrderDetailsPage.qml"},
                                                 {"linkKey","order_id"}}},
                                                 {"inventory_adjustment_id",tr("Adjustment ID")}


                                            },


                            parent}
{

}
