#ifndef NETWORKEDJSONMODEL_H
#define NETWORKEDJSONMODEL_H

#include "jsonmodel.h"
//#include <network/messagehandler.h>
#include <networkmanager.h>
class NetworkedJsonModel : public JsonModel
{
    Q_OBJECT
public:
    NetworkedJsonModel(QString Url,QObject *parent=nullptr);

    void onTableRecieved(NetworkResponse *reply);
    void refresh();
    void requestData();
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

private:
    QString url;
    NetworkManager manager;
};

#endif // NETWORKEDJSONMODEL_H
