#ifndef APPNETWORKEDJSONMODEL_H
#define APPNETWORKEDJSONMODEL_H

#include "networkedjsonmodel.h"

class AppNetworkedJsonModel : public NetworkedJsonModel
{
    Q_OBJECT
public:
    AppNetworkedJsonModel(QString url, const ColumnList &columns=ColumnList(), QObject *parent = nullptr, bool usePagination=true);
    Q_INVOKABLE AppNetworkedJsonModel(const ColumnList &columns=ColumnList(),QObject *parent = nullptr);

    Q_PROPERTY(QJsonObject filter READ filter WRITE setFilter NOTIFY filterChanged)

    Q_INVOKABLE QJsonObject filter() const;
    const QString &direction() const;
    void setDirection(const QString &newDirection);

    bool usePagination() const;
    void setUsePagination(bool newUsePagination);

signals:
    void filterChanged(QJsonObject filter);

    void usePaginationChanged();

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
    bool m_usePagination;




    Q_PROPERTY(bool usePagination READ usePagination WRITE setUsePagination NOTIFY usePaginationChanged)
};

#endif // APPNETWORKEDJSONMODEL_H
