#include "productsattributesattributesmodel.h"

ProductsAttributesAttributesModel::ProductsAttributesAttributesModel(QObject *parent)
    : AppNetworkedJsonModel ("/productAttributes",{
                             {"id",tr("ID")} ,
                             {"name",tr("Name")},
                                                   {"type",tr("Type")},

                                                   {"filter_visible","Show In Filter",QString(),false,"check"},
                                                   {"products_visible","Show In Products",QString(),false,"check"}
                                                                    },parent)
{

}
