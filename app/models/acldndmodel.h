#ifndef ACLDNDMODEL_H
#define ACLDNDMODEL_H

#include <jsonmodel.h>

class AclDnDModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit AclDnDModel(QObject *parent = nullptr);

signals:

};

#endif // ACLDNDMODEL_H
