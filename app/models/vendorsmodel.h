#ifndef VENDORSMODEL_H
#define VENDORSMODEL_H

#include "appnetworkedjsonmodel.h"

class VendorsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit VendorsModel(QObject *parent = nullptr);



signals:

};

#endif // VENDORSMODEL_H
