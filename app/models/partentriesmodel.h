#ifndef PARTENTRIESMODEL_H
#define PARTENTRIESMODEL_H

#include "appnetworkedjsonmodel.h"

// Entries (the part rows) of a parts-catalogue section. /partcatalogue/entries
// returns each entry with its nested official "part"; this flattens part_number
// + description onto the row so the table columns resolve. Filtered by
// {catalogue_id, section_id} set from the page.
class PartEntriesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE PartEntriesModel(QObject *parent = nullptr);

    virtual QJsonArray filterData(QJsonArray data) override;
};

#endif // PARTENTRIESMODEL_H
