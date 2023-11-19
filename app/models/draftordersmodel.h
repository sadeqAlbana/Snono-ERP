#ifndef DRAFTORDERSMODEL_H
#define DRAFTORDERSMODEL_H

#include "appnetworkedjsonmodel.h"

class DraftOrdersModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit DraftOrdersModel(QObject *parent = nullptr);
};

#endif // DRAFTORDERSMODEL_H
