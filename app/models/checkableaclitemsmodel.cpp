
#include "checkableaclitemsmodel.h"

CheckableAclItemsModel::CheckableAclItemsModel(QObject *parent)
    : CheckableListModel("name","permission",QSet<int>(),"/aclItems", parent)
{

}

