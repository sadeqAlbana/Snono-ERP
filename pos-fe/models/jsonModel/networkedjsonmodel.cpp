#include "networkedjsonmodel.h"
#include <QJsonDocument>
#include <QDebug>
NetworkedJsonModel::NetworkedJsonModel(QString Url, QObject *parent) : JsonModel(parent), url(Url)
{
}

void NetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{
    setupData(reply->jsonObject().value("data").toArray());

    emit dataRecevied();
}

void NetworkedJsonModel::refresh()
{
    requestData();
}

void NetworkedJsonModel::requestData()
{
    manager.get(url)->subcribe(this,&NetworkedJsonModel::onTableRecieved);
}


Qt::ItemFlags NetworkedJsonModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return JsonModel::flags(index);
}

bool NetworkedJsonModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    return true;
}





