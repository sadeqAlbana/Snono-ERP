#ifndef CATALOGUESMODEL_H
#define CATALOGUESMODEL_H

#include "appnetworkedjsonmodel.h"

// List model for external supplier catalogue items (/catalogues). Read-only.
// Core columns are fixed; any catalog_attributes returned in the response's
// "attributes" array become extra columns (same dynamic-column mechanism as
// ProductsModel), so per-source EAV attributes show up automatically.
class CataloguesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE CataloguesModel(QObject *parent = nullptr);

    virtual QJsonArray filterData(QJsonArray data) override;

protected:
    void onTableRecieved(NetworkResponse *reply) override;

private:
    QJsonArray m_wantedColumns;
};

#endif // CATALOGUESMODEL_H
