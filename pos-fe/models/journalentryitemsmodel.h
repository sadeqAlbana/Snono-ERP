#ifndef JOURNALENTRYITEMSMODEL_H
#define JOURNALENTRYITEMSMODEL_H

#include "jsonModel/networkedjsonmodel.h"

class JournalEntryItemsModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit JournalEntryItemsModel(QObject *parent = nullptr);

    virtual ColumnList columns() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
};

#endif // JOURNALENTRYITEMSMODEL_H
