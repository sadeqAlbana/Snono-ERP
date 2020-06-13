#ifndef USERSMODEL_H
#define USERSMODEL_H

#include "jsonModel/networkedjsonmodel.h"

class UsersModel : public NetworkedJsonModel
{
public:
    UsersModel(QObject *parent=nullptr);
    virtual ColumnList columns() const override;
};

#endif // USERSMODEL_H
