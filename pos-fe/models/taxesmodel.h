#ifndef TAXESMODEL_H
#define TAXESMODEL_H

#include "appnetworkedjsonmodel.h"

class TaxesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit TaxesModel(QObject *parent = nullptr);

signals:

};

#endif // TAXESMODEL_H
