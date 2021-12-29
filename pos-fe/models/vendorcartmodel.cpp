#include "vendorcartmodel.h"

VendorCartModel::VendorCartModel(QObject *parent) : JsonModel(QJsonArray(),{
                                                              Column{"product_id","ID"},
                                                              Column{"cost","Cost"},
                                                              Column{"name","Name"},
                                                              Column{"qty","Qty"},
                                                              Column{"sku","SKU"},
                                                              Column{"thumb","Thumb"},
                                                              Column{"total","Total"}

                                                              }
                                                              ,parent)
{

}

bool VendorCartModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success=JsonModel::setData(index,value,role);
    if(success){
        QString key=headerData(index.column(),Qt::Horizontal,Qt::EditRole).toString();
        if(key=="qty" || key=="cost"){
            double cost=data(index.row(),"cost").toDouble();
            double qty=data(index.row(),"qty").toDouble();
            JsonModel::setData(index.row(),"total",cost*qty);
            emit cartTotalChanged(cartTotal());
        }

    }

    return success;
}

double VendorCartModel::cartTotal()
{
    double total=0;
    for(int i=0; i<rowCount(); i++){
        total+=JsonModel::data(i,"total").toDouble();
    }
    return total;
}

void VendorCartModel::refreshCartTotal()
{
    emit cartTotalChanged(cartTotal());
}

