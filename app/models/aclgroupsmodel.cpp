#include "aclgroupsmodel.h"

AclGroupsModel::AclGroupsModel(QObject *parent)
    : AppNetworkedJsonModel{"/acl/groups",
                            {
                                {"id",tr("ID")},
                                {"name",tr("Name")}
                            },
                            parent}
{
    requestData();
}

