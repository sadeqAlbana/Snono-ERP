#ifndef ACLGROUPSMODEL_H
#define ACLGROUPSMODEL_H


#include "appnetworkedjsonmodel.h"

class AclGroupsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit AclGroupsModel(QObject *parent = nullptr);
};


#endif // ACLGROUPSMODEL_H
