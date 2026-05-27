#include "partentriesmodel.h"
#include <QJsonArray>
#include <QJsonObject>

PartEntriesModel::PartEntriesModel(QObject *parent)
    : AppNetworkedJsonModel("/partcatalogue/entries", JsonModelColumnList(), parent)
{
    m_columns = JsonModelColumnList{
        {"seq_no", tr("No.")},
        {"part_number", tr("Part #")},
        {"description", tr("Description")},
        {"qty", tr("Qty")},
        {"start_year", tr("Year")},
        {"color", tr("Color")},
        {"actions", tr("Sources"), QString(), false, "action"},
    };
    setSortKey("id");
    setDirection("asc");
}

// The /partcatalogue/entries endpoint already returns part_number/description
// flattened (and source_count), so no client-side reshaping is needed.
QJsonArray PartEntriesModel::filterData(QJsonArray data)
{
    return data;
}
