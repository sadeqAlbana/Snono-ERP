#include "aclitemsmodel.h"

AclItemsModel::AclItemsModel(QObject *parent)
    : AppNetworkedJsonModel{"/aclItems",
                            JsonModelColumnList{{"permission",tr("Permission")},{"category",tr("Category")}},
                            parent}
{
}
