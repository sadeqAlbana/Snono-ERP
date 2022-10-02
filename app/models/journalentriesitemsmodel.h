#ifndef JOURNALENTRIESITEMSMODEL_H
#define JOURNALENTRIESITEMSMODEL_H

#include "appnetworkedjsonmodel.h"

class JournalEntriesItemsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit JournalEntriesItemsModel(QObject *parent = nullptr);

signals:

};

#endif // JOURNALENTRIESITEMSMODEL_H
