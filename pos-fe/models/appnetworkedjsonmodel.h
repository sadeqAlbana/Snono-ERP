#ifndef APPNETWORKEDJSONMODEL_H
#define APPNETWORKEDJSONMODEL_H

#include "networkedjsonmodel.h"

class AppNetworkedJsonModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    AppNetworkedJsonModel(QString url,const ColumnList &columns=ColumnList(),QObject *parent = nullptr);
    Q_INVOKABLE AppNetworkedJsonModel(const ColumnList &columns=ColumnList(),QObject *parent = nullptr);

    Q_PROPERTY(QJsonObject filter READ filter WRITE setFilter NOTIFY filterChanged)

    Q_INVOKABLE QJsonObject filter() const;
    const QString &direction() const;
    void setDirection(const QString &newDirection);

signals:
    void filterChanged(QJsonObject filter);

protected:
    void onTableRecieved(NetworkResponse *reply);
    void requestData() override;
    Q_INVOKABLE void setSearchQuery(const QString _query);
    Q_INVOKABLE void search();
    Q_INVOKABLE void setFilter(const QJsonObject &filter);

private:
    QString _query;
    QJsonObject m_filter;
    QJsonObject m_oldFilter;
    QString m_direction;




};

#endif // APPNETWORKEDJSONMODEL_H
