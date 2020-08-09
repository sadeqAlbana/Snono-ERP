#ifndef JOURNALENTRYITEMSMODEL_H
#define JOURNALENTRYITEMSMODEL_H

#include "jsonModel/networkedjsonmodel.h"

class JournalEntryItemsModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit JournalEntryItemsModel(QObject *parent = nullptr);

    virtual ColumnList columns() const override;
};

#endif // JOURNALENTRYITEMSMODEL_H
