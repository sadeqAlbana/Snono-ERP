#ifndef PRODUCTSDEMOMODEL_H
#define PRODUCTSDEMOMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class ProductsDemoModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit ProductsDemoModel(QObject *parent = nullptr);


    virtual QJsonArray filterData(QJsonArray data) override;

protected:
    void onTableRecieved(NetworkResponse *reply) override;
private:
    QJsonArray m_wantedColumns;


};

#endif // PRODUCTSDEMOMODEL_H
