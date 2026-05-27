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
    };
    setSortKey("id");
    setDirection("asc");
}

// Flatten the nested official part onto each entry row.
QJsonArray PartEntriesModel::filterData(QJsonArray data)
{
    for (int i = 0; i < data.size(); i++) {
        QJsonObject row = data.at(i).toObject();
        const QJsonObject part = row.value("part").toObject();
        row["part_number"] = part.value("part_number");
        row["description"] = part.value("description");
        data.replace(i, row);
    }
    return data;
}
