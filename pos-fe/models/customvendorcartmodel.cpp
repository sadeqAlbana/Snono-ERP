#include "customvendorcartmodel.h"
#include "posnetworkmanager.h"
CustomVendorCartModel::CustomVendorCartModel(QObject *parent) : JsonModel(QJsonArray(),{
                                                              Column{"name","Name"},
                                                              Column{"cost","Cost"},
                                                              Column{"qty","Qty"},
                                                              Column{"total","Total"}

                                                              }
                                                              ,parent)
{
    connect(this,&CustomVendorCartModel::dataChanged,this,&CustomVendorCartModel::refreshCartTotal);
    connect(this,&CustomVendorCartModel::rowsInserted,this,&CustomVendorCartModel::refreshCartTotal);
    connect(this,&CustomVendorCartModel::rowsRemoved,this,&CustomVendorCartModel::refreshCartTotal);
    appendRecord(QJsonObject{{"name",""},{"cost",1000},{"qty",1},{"total",1000}});

}

bool CustomVendorCartModel::setData(const QModelIndex &index, const QVariant &value, int role)
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

double CustomVendorCartModel::cartTotal()
{
    double total=0;
    for(int i=0; i<rowCount(); i++){
        total+=JsonModel::data(i,"total").toDouble();
    }
    return total;
}

void CustomVendorCartModel::refreshCartTotal()
{
    emit cartTotalChanged(cartTotal());
}


