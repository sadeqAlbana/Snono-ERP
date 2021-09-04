#ifndef CUSTOMERSMODEL_H
#define CUSTOMERSMODEL_H

#include "appnetworkedjsonmodel.h"

class CustomersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit CustomersModel(QObject *parent = nullptr);

};

#endif // CUSTOMERSMODEL_H
