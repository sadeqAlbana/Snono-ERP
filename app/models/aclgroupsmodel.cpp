#include "aclgroupsmodel.h"

AclGroupsModel::AclGroupsModel(QObject *parent)
    : AppNetworkedJsonModel{"/acl/groups",
                            JsonModelColumnList{
//                                {"id",tr("id")},
//                                {"name",tr("name")}
                            },
                            parent}
{
}

