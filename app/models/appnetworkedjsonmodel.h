#ifndef APPNETWORKEDJSONMODEL_H
#define APPNETWORKEDJSONMODEL_H

#include <networkedjsonmodel.h>
#include <QQmlEngine>
class AppNetworkedJsonModel : public NetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool usePagination READ usePagination WRITE setUsePagination NOTIFY usePaginationChanged)

public:
    Q_INVOKABLE AppNetworkedJsonModel(QString url, const JsonModelColumnList &columns=JsonModelColumnList(), QObject *parent = nullptr, bool usePagination=true);
    Q_INVOKABLE AppNetworkedJsonModel(const JsonModelColumnList &columns=JsonModelColumnList(),QObject *parent = nullptr);

    Q_PROPERTY(QJsonObject filter READ filter WRITE setFilter NOTIFY filterChanged)

    Q_INVOKABLE QJsonObject filter() const;
//    const QString &direction() const;
//    void setDirection(const QString &newDirection);

    bool usePagination() const;
    void setUsePagination(bool newUsePagination);

    const QString &sortKey() const;
    void setSortKey(const QString &newSortKey);

    const QString &direction() const;
    void setDirection(const QString &newDirection);

signals:
    void filterChanged(QJsonObject filter);

    void usePaginationChanged();

    void sortKeyChanged();

    void directionChanged();

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
    QString m_sortKey=QStringLiteral("id");




    Q_PROPERTY(QString sortKey READ sortKey WRITE setSortKey NOTIFY sortKeyChanged)
    Q_PROPERTY(QString direction READ direction WRITE setDirection NOTIFY directionChanged)
};

#endif // APPNETWORKEDJSONMODEL_H
