#include "newinvoicemodel.h"


NewInvoiceModel::NewInvoiceModel(QObject *parent)
    : JsonModel(QJsonArray(),
                JsonModelColumnList{
                    {"no",tr("No")},
                    {"item",tr("Item"),QString(),false,"combo"},
                    {"description",tr("Description")},
                    {"qty",tr("Qty"),QString(),false,"number"},
                    {"amount",tr("Amount"),QString(),false,"number"},
                    {"total",tr("Total"),QString(),false,"number"}

                },
                parent)
{



}


Qt::ItemFlags NewInvoiceModel::flags(const QModelIndex &index) const
{
    switch(index.column()){
    case 1:
    case 2:
    case 3:
    case 4: return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
    default: return JsonModel::flags(index);
    }
}

void NewInvoiceModel::newEntry()
{
    QJsonObject record=this->record();

    record["no"]=rowCount()+1;


    appendRecord(record);
}
