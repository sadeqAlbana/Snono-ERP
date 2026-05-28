#include "cataloguesmodel.h"
#include <networkresponse.h>
#include <QJsonArray>

CataloguesModel::CataloguesModel(QObject *parent)
    : AppNetworkedJsonModel("/catalogues", JsonModelColumnList(), parent)
{
    m_columns = JsonModelColumnList{
        {"id", tr("ID")},
        {"part_number", tr("Part #")},
        {"name", tr("Name")},
        {"official_part", tr("Official Part #")},
        {"official_name", tr("Official Name")},
        {"price", tr("Price"), QString(), false, "currency"},
        {"availability", tr("Availability")},
        {"stock_label", tr("In Stock")},
        {"last_seen_at", tr("Last Seen"), QString(), false, "datetime"},
        {"url", tr("Link"), QString(), false, "link"},
    };
    setDirection("desc");
}

// Flatten each item's EAV attributes onto the row so the dynamic columns
// (added in onTableRecieved) have values. Mirrors ProductsModel::filterData.
QJsonArray CataloguesModel::filterData(QJsonArray data)
{
    QStringList wanted;
    for (const QJsonValue &value : m_wantedColumns)
        wanted << value["id"].toString();

    for (int i = 0; i < data.size(); i++) {
        QJsonObject item = data.at(i).toObject();
        QJsonArray attributes = item["attributes"].toArray();
        for (int j = 0; j < attributes.size(); j++) {
            QJsonObject attribute = attributes.at(j).toObject();
            attribute["type"] = attribute["attributes_attribute"].toObject()["type"];
            QString attributeId = attribute["attribute_id"].toString();
            attributes.replace(j, attribute);
            if (wanted.contains(attributeId))
                item[attributeId] = attribute["value"];
        }
        item["attributes"] = attributes;

        // Flatten the linked official part (part_id -> parts) onto the row.
        const QJsonObject part = item.value("part").toObject();
        item["official_part"] = part.value("part_number");
        item["official_name"] = part.value("description");

        // Tri-state stock (1/0/null) -> readable label.
        const QJsonValue inStock = item.value("in_stock");
        if (inStock.isNull() || inStock.isUndefined())
            item["stock_label"] = QStringLiteral("—");
        else
            item["stock_label"] = inStock.toVariant().toInt() == 1 ? tr("In Stock")
                                                                   : tr("Out of Stock");

        data.replace(i, item);
    }
    return data;
}

void CataloguesModel::onTableRecieved(NetworkResponse *reply)
{
    if (m_wantedColumns.isEmpty()) {
        m_wantedColumns = reply->json("attributes").toArray();
        for (const QJsonValue &value : m_wantedColumns)
            m_columns.append(JsonModelColumn{value["id"].toString(), value["name"].toString(),
                                             QString(), false, value["type"].toString()});
    }
    AppNetworkedJsonModel::onTableRecieved(reply);
}
