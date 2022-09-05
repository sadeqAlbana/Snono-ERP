#include "taxesmodel.h"

TaxesModel::TaxesModel(QObject *parent) : AppNetworkedJsonModel ("/taxes",{
                                                                 {"id",tr("ID")} ,
                                                                 {"name",tr("Name")} ,
                                                                 {"type",tr("Type"),QString(),"taxType"} ,
                                                                 {"value",tr("Value")} ,
                                                                 {"account_id",tr("Account ID")}
                                                                 },parent)
{
    requestData();
}
