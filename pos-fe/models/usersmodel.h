#ifndef USERSMODEL_H
#define USERSMODEL_H

#include "appnetworkedjsonmodel.h"

class UsersModel : public AppNetworkedJsonModel
{
public:
    UsersModel(QObject *parent=nullptr);
};

#endif // USERSMODEL_H
