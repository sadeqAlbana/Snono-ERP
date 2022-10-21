#include "productsattributesattributesmodel.h"

ProductsAttributesAttributesModel::ProductsAttributesAttributesModel(QObject *parent)
    : AppNetworkedJsonModel ("/proucts/attributes",{
                             {"id",tr("ID")} ,
                             {"name",tr("Name")}},parent)
{
    requestData();
}
