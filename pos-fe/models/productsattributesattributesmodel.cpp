#include "productsattributesattributesmodel.h"

ProductsAttributesAttributesModel::ProductsAttributesAttributesModel(QObject *parent)
    : AppNetworkedJsonModel ("/proucts/attributes",{
                             Column{"id","ID"} ,
                             Column{"name","Name"}},parent)
{
    requestData();
}
