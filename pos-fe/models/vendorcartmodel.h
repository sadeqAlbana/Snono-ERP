#ifndef VENDORCARTMODEL_H
#define VENDORCARTMODEL_H

#include "jsonmodel.h"

class VendorCartModel : public JsonModel
{
    Q_OBJECT
public:
    explicit VendorCartModel(QObject *parent = nullptr);

signals:

};

#endif // VENDORCARTMODEL_H
