#include "returnordermodel.h"

ReturnOrderModel::ReturnOrderModel(QObject *parent) : JsonModel(QJsonArray(),{
                                                                                        Column{"name",tr("Product"),"products"} ,
                                                                                        Column{"qty",tr("Quantity")} ,
                                                                                        Column{"unit_price",tr("Unit Price"),QString(),"currency"} ,
                                                                                        Column{"subtotal",tr("Subtotal"),QString(),"currency"} ,
                                                                                        Column{"total",tr("Total"),QString(),"currency"}},parent)
{
    setCheckable(true);
}

bool ReturnOrderModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success=JsonModel::setData(index,value,role);
    if(success){
        QString key=headerData(index.column(),Qt::Horizontal,Qt::EditRole).toString();
        if(key=="qty" || role==Qt::CheckStateRole){
            double cost=data(index.row(),"unit_price").toDouble();
            double qty=data(index.row(),"qty").toDouble();
            JsonModel::setData(index.row(),"total",cost*qty);
            emit returnTotalChanged(returnTotal());
        }

    }

    return success;
}

double ReturnOrderModel::returnTotal()
{
    double total=0;
    for(int i=0; i<rowCount(); i++){
        Qt::CheckState state=static_cast<Qt::CheckState>(data(index(i,0),Qt::CheckStateRole).toInt());
        if(state==Qt::Checked || state==Qt::PartiallyChecked)
        total+=JsonModel::data(i,"total").toDouble();
    }
    return total;
}

void ReturnOrderModel::refreshReturnTotal()
{
    emit returnTotalChanged(returnTotal());

}

QJsonArray ReturnOrderModel::returnedLines()
{
    QJsonArray returned;
    for(int i=0; i<rowCount(); i++){
        Qt::CheckState state=static_cast<Qt::CheckState>(data(index(i,0),Qt::CheckStateRole).toInt());
        if(state==Qt::Checked || state==Qt::PartiallyChecked)
        returned << jsonObject(i);
    }
    return returned;
}
