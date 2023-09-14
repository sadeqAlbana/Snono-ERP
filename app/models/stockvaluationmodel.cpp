#include "stockvaluationmodel.h"

StockValuationModel::StockValuationModel(QObject *parent)
    : AppNetworkedJsonModel{"/stock/valuation",{
                                                {"description",tr("Description")},
                                                {"name",tr("Product"),"product"},
                                                {"qty",tr("Qty")},
                                                 {"cost",tr("Value")},
                                                {"total",tr("Total")},
                                                {"date",tr("Date")},
                                                 {"journal_entry_id",tr("Journal Entry")},
                                                 {"order_id",tr("Order"),QString(),"link"},
                                                 {"inventory_adjustment_id",tr("Adjustment ID")}


                                            },


                            parent}
{

}

QVariant StockValuationModel::data(const QModelIndex &index, int role) const
{

    if(!(index.isValid() && index.column()<columnCount() && index.row()<rowCount())){
        return QVariant();
    }

    JsonModelColumn column=m_columns.value(index.column());

    if(column.m_type=="link"){

    }

}
