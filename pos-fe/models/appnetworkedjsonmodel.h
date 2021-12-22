#ifndef APPNETWORKEDJSONMODEL_H
#define APPNETWORKEDJSONMODEL_H

#include "networkedjsonmodel.h"

class AppNetworkedJsonModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    explicit AppNetworkedJsonModel(QString url,const ColumnList &columns=ColumnList(),QObject *parent = nullptr);
    Q_INVOKABLE QJsonObject filter() const;

protected:
    void onTableRecieved(NetworkResponse *reply);
    void requestData() override;
    Q_INVOKABLE void setSearchQuery(const QString _query);
    Q_INVOKABLE void search();
    Q_INVOKABLE void setFilter(const QJsonObject &filter);

private:
    QString _query;
    QJsonObject m_filter;




};

#endif // APPNETWORKEDJSONMODEL_H
