#include "aclgroupsmodel.h"

AclGroupsModel::AclGroupsModel(QObject *parent)
    : AppNetworkedJsonModel{"/aclGroups",
                            {
                                {"id",tr("ID")},
                                {"name",tr("Name")},
                                {"description",tr("Description")}
                            },
                            parent}
{
   
}

