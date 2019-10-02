#include "networkedjsonmodel.h"
#include <QDebug>
NetworkedJsonModel::NetworkedJsonModel(QString Url, QObject *parent) : JsonModel(parent)
{
    url=Url;
    qDebug()<<"url : " <<url;
    requestData();
}



void NetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{
    insertData(reply->json("data").toArray());
}

void NetworkedJsonModel::refresh()
{
    requestData();
}

void NetworkedJsonModel::requestData()
{

    QJsonDocument doc=QJsonDocument::fromJson(QString(R"({
                                              "page": 1,
                                              "size": %1,
                                              "sortBy": "id",
                                              "sortOrder": "desc"
                                            }
 )").arg(10).toUtf8());
    //manager.post(url,doc)->subcribe(this,&NetworkedJsonModel::onTableRecieved);
    manager.post(url,doc.object())->subcribe(this,&NetworkedJsonModel::onTableRecieved);
}


Qt::ItemFlags NetworkedJsonModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return JsonModel::flags(index) | Qt::ItemIsEditable;
}

bool NetworkedJsonModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    bool success=JsonModel::setData(index,value,role);

    if (success)
    {

        QVariant id = record(index.row()).value("id");
        QString column=headerData(index.column(),Qt::Horizontal).toString();

        manager.put("/user",
                    QJsonObject
                    {
                        {"id",id.toString()},
                        {"column",column},
                        {"value",value.toString()}
                    }

                    )->subcribe([&](Response *res)
        {

            qDebug()<<res->status();
        });
    }
    return success;
}
