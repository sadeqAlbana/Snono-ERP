#ifndef USERSMODEL_H
#define USERSMODEL_H

#include "appnetworkedjsonmodel.h"

class UsersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    UsersModel(QObject *parent=nullptr);
};

#endif // USERSMODEL_H
