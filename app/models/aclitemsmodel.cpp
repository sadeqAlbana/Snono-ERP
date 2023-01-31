#include "aclitemsmodel.h"

AclItemsModel::AclItemsModel(QObject *parent)
    : AppNetworkedJsonModel{"/aclItems",
                            JsonModelColumnList(),
                            parent}
{
    requestData();
}
