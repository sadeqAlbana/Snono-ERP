#include "aclitemsmodel.h"

AclItemsModel::AclItemsModel(QObject *parent)
    : AppNetworkedJsonModel{"/acl/items",
                            JsonModelColumnList(),
                            parent}
{
    requestData();
}
