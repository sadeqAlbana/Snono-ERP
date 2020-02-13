#include "networkedjsonmodel.h"
#include <QJsonDocument>
#include <QDebug>
NetworkedJsonModel::NetworkedJsonModel(QString Url, QObject *parent) : JsonModel(parent), url(Url)
{
}

void NetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{
    setupData(reply->jsonObject().value("data").toArray());
}

void NetworkedJsonModel::refresh()
{
    requestData();
}

void NetworkedJsonModel::requestData()
{
    manager.post(url,QJsonObject{{"page"     , 1},
                                 {"size"     , 10},
                                 {"sortBy"   , "id"},
                                 {"sortOrder", "desc"}})->subcribe(this,&NetworkedJsonModel::onTableRecieved);
}


Qt::ItemFlags NetworkedJsonModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return JsonModel::flags(index) | Qt::ItemIsEditable;
}

bool NetworkedJsonModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
//    bool success=JsonModel::setData(index,value,role);

//    if (success)
//    {

//        QVariant id = record(index.row()).value("id");
//        QString column=headerData(index.column(),Qt::Horizontal).toString();

//        manager.put("/user",
//                    QJsonObject
//                    {
//                        {"id",id.toString()},
//                        {"column",column},
//                        {"value",value.toString()}
//                    }

//                    )->subcribe([&](Response *res)
//        {

//            qDebug()<<res->status();
//        });
//    }
//    return success;
    return true;
}

QJsonValue NetworkedJsonModel::requestParams() const
{
    return _requestParams;
}

void NetworkedJsonModel::setRequestParams(const QJsonValue &requestParams)
{
    _requestParams = requestParams;
}



