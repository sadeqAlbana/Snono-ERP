#ifndef ACLITEMSMODEL_H
#define ACLITEMSMODEL_H

#include "appnetworkedjsonmodel.h"

class AclItemsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit AclItemsModel(QObject *parent = nullptr);

};

#endif // ACLITEMSMODEL_H
