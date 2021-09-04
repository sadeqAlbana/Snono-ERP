#ifndef JOURNALENTRYITEMSMODEL_H
#define JOURNALENTRYITEMSMODEL_H

#include "appnetworkedjsonmodel.h"

class JournalEntryItemsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit JournalEntryItemsModel(QObject *parent = nullptr);

};

#endif // JOURNALENTRYITEMSMODEL_H
