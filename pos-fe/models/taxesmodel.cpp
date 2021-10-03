#include "taxesmodel.h"

TaxesModel::TaxesModel(QObject *parent) : AppNetworkedJsonModel ("/taxes",ColumnList() <<
                                                                  Column{"id","ID"} <<
                                                                  Column{"name","Name"} <<
                                                                  Column{"type","Type"} <<
                                                                  Column{"value","Value"} <<
                                                                  Column{"account_id","Account ID"},parent)
{
    requestData();
}
