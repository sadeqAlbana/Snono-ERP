#include "stockmovesmodel.h"



StockMovesModel::StockMovesModel(QObject *parent)
    : AppNetworkedJsonModel{"/stock/moves",{
                                                {"description",tr("Description")},
                                             {"name",tr("Product"),"product",false,"link",
                                              QVariantMap{{"link","qrc:/PosFe/qml/pages/products/ProductForm.qml"},
                                                          {"linkKey","product_id"}}},
                                                {"name",tr("Origin"),"location"},
                                                {"name",tr("Destination"),"destination"},
                                                {"qty",tr("Qty")},
                                                {"date",tr("Date")}


                                            },


                            parent}
{

}
