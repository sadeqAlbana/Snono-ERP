#include "productsattributesattributesmodel.h"

ProductsAttributesAttributesModel::ProductsAttributesAttributesModel(QObject *parent)
    : AppNetworkedJsonModel ("/productAttributes",{
                             {"id",tr("ID")} ,
                             {"name",tr("Name")}},parent)
{

}
