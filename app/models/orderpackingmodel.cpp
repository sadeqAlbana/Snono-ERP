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
    if(!index.isValid()){
        return false;
    }


    if(role==Qt::CheckStateRole){
        int state=value.toInt();
        if(data(index,Qt::CheckStateRole)==state){
            return true;
        }
        if(state==Qt::Checked){
            JsonModel::setData(index.row(),"packed_qty",data(index.row(),"qty")); //call JsonModel, set fully packed, avoids recursion
        }
        if(state==Qt::Unchecked){
            JsonModel::setData(index.row(),"packed_qty",0 ); //call JsonModel, set unpacked, avoids recursion
        }

    }

    QString key=headerData(index.column(),Qt::Horizontal,Qt::EditRole).toString();

    if(key=="packed_qty" && role==Qt::EditRole){
        int requiredQty=data(index.row(),"qty").toInt();
        int packedQty=value.toInt();
        Qt::CheckState newCheckState;
        //now we set the checkstate
        if(packedQty<0 ||packedQty>requiredQty){ //wtf
            return false;
        }
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
            JsonModel::setData(index,newCheckState,Qt::CheckStateRole); //call JsonModel to avoid returning to this method
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
