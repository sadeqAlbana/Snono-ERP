#include "orderpackingmodel.h"

OrderPackingModel::OrderPackingModel(QObject *parent)
    : JsonModel(QJsonArray(),{
                               {"name",tr("Product")} ,
                               {"qty",tr("Quantity")} ,
                               {"packed_qty",tr("Packed")} ,
                               {"unit_price",tr("Unit Price"),QString(),false,"currency"} ,
                               {"total",tr("Total"),QString(),false,"currency"} ,
                               {"sku",tr("SKU")},
                               {"barcode",tr("Barcode")},
                               {"thumb",tr("Thumb"),QString(),false,"image"}


                              }

                ,parent)
{
    setCheckable(true);

}

bool OrderPackingModel::add(const QString barcode)
{
    for(int i=0; i<rowCount(); i++){
        if(data(i,"barcode").toString()==barcode){
            int qty=data(i,"packed_qty").toInt();
            setData(i,"packed_qty",++qty);
            return true;
        }
    }
    return false;
}
