#include "stocklocationmodel.h"

StockLocationModel::StockLocationModel(QObject *parent)
    : AppNetworkedJsonModel{"/stocklocation",
                            {{"name",tr("Name")},
                            {"stock",tr("Stock")}},

                            parent}
{

}
