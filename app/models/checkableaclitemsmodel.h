
#ifndef CHECKABLEACLITEMSMODEL_H
#define CHECKABLEACLITEMSMODEL_H


#include <QObject>
#include "jsonModel/checkablelistmodel.h"

class CheckableAclItemsModel : public CheckableListModel
{
    Q_OBJECT
    QML_ELEMENT
        public:
                 explicit CheckableAclItemsModel(QObject *parent = nullptr);

signals:

};

#endif // CHECKABLEACLITEMSMODEL_H
