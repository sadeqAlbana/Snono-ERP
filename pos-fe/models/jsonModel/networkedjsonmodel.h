#ifndef NETWORKEDJSONMODEL_H
#define NETWORKEDJSONMODEL_H

#include "jsonmodel.h"
//#include <network/messagehandler.h>
#include "posnetworkmanager.h"



class NetworkedJsonModel : public JsonModel
{
    Q_OBJECT
public:
    NetworkedJsonModel(QString Url,QObject *parent=nullptr);

    virtual void onTableRecieved(NetworkResponse *reply);
    void refresh();
    virtual void requestData();
    virtual Qt::ItemFlags flags(const QModelIndex& index) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

//    QJsonValue requestParams() const;
//    void setRequestParams(const QJsonValue &requestParams);



protected:
    QString url;
    PosNetworkManager manager;
    QJsonValue _requestParams;

signals:
    void dataRecevied();
};

#endif // NETWORKEDJSONMODEL_H
