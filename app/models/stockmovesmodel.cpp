#include "stockmovesmodel.h"



StockMovesModel::StockMovesModel(QObject *parent)
    : AppNetworkedJsonModel{"/stock/moves",{
                                                {"description",tr("Description")},
                                                {"name",tr("Product"),"product"},
                                                {"name",tr("Origin"),"location"},
                                                {"name",tr("Destination"),"destination"},
                                                {"qty",tr("Qty")},
                                                {"date",tr("Date")}


                                            },


                            parent}
{

}
