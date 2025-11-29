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

bool OrderPackingModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    QString key=headerData(index.column(),Qt::Horizontal,Qt::EditRole).toString();

        if(key=="packed_qty" && role==Qt::EditRole){
            int requiredQty=data(index.row(),"qty").toInt();
            int packedQty=value.toInt();
            if(packedQty>requiredQty){
                return false;
            }else{
                //now we set the checkstate
                Qt::CheckState newCheckState;
                if(packedQty==0){
                    newCheckState=Qt::Unchecked;
                }
                if(packedQty==requiredQty){
                    newCheckState=Qt::Checked;
                }
                if(packedQty>0 && packedQty<requiredQty){
                    newCheckState=Qt::PartiallyChecked;
                }
                if(data(index,Qt::CheckStateRole)!=newCheckState){
                    setData(index,newCheckState,Qt::CheckStateRole);

                }
            }
        }

    return JsonModel::setData(index,value,role);
}

bool OrderPackingModel::add(const QString barcode)
{
    for(int i=0; i<rowCount(); i++){
        if(data(i,"barcode").toString()==barcode){
            int qty=data(i,"packed_qty").toInt();
            JsonModel::setData(i,"packed_qty",++qty);
            return true;
        }
    }
    return false;
}
