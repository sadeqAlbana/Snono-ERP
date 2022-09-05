#include "productsattributesattributesmodel.h"

ProductsAttributesAttributesModel::ProductsAttributesAttributesModel(QObject *parent)
    : AppNetworkedJsonModel ("/proucts/attributes",{
                             Column{"id",tr("ID")} ,
                             Column{"name",tr("Name")}},parent)
{
    requestData();
}
