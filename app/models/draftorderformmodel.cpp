#include "draftorderformmodel.h"




DraftOrderFormModel::DraftOrderFormModel(QObject *parent) : JsonModel (QJsonArray(),{
                               JsonModelColumn{"name",tr("Name"),QString(),true} ,
                               {"description",tr("Description"),QString(),true} ,
                                                  {"unit_price",tr("Price"),QString(),true,"number"} ,
                                                  {"qty",tr("Qty"),QString(),true,"number"} ,
                               {"total",tr("Total"),QString(),false,"number"}},
                parent)


{
    connect(this,&DraftOrderFormModel::dataChanged,this,&DraftOrderFormModel::refreshCartTotal);
    connect(this,&DraftOrderFormModel::rowsInserted,this,&DraftOrderFormModel::refreshCartTotal);
    connect(this,&DraftOrderFormModel::rowsRemoved,this,&DraftOrderFormModel::refreshCartTotal);
    appendRecord(QJsonObject{{"name",""},{"description",""},{"unit_price",1000},{"qty",1},{"total",1000}});
}


bool DraftOrderFormModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success=JsonModel::setData(index,value,role);
    if(success){
        QString key=headerData(index.column(),Qt::Horizontal,Qt::EditRole).toString();
        if(key=="qty" || key=="unit_price"){
            double price=data(index.row(),"unit_price").toDouble();
            double qty=data(index.row(),"qty").toDouble();

            JsonModel::setData(index.row(),"total",price*qty);
            emit cartTotalChanged();
        }

    }

    return success;
}


double DraftOrderFormModel::cartTotal()
{
    double total=0;
    for(int i=0; i<rowCount(); i++){
        total+=JsonModel::data(i,"total").toDouble();
    }
    return total;
}

void DraftOrderFormModel::refreshCartTotal()
{
    emit cartTotalChanged();
}

