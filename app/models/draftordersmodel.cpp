#include "draftordersmodel.h"

DraftOrdersModel::DraftOrdersModel(QObject *parent)
    : AppNetworkedJsonModel("/draftOrders",{
                                             {"id",tr("ID")} ,
                                             {"name",tr("Name")} ,

                                             {"name",tr("Customer"),"customer",false,

                                                 "link",
                                                 QVariantMap{{"link","qrc:/PosFe/qml/pages/customers/CustomerForm.qml"},
                                                             {"linkKey","customer_id"}}
                                             } ,
                                             {"created_at",tr("Date"),QString(),false,"datetime"} ,
                                             {"total",tr("Total"),QString(),false,"currency"} }
                            ,parent)
{}
