#ifndef APPNETWORKEDJSONMODEL_H
#define APPNETWORKEDJSONMODEL_H

#include <networkedjsonmodel.h>
#include <QQmlEngine>


class AppNetworkedJsonModel : public NetworkedJsonModel, public QQmlParserStatus
{
    Q_OBJECT
    QML_ELEMENT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(bool usePagination READ usePagination WRITE setUsePagination NOTIFY usePaginationChanged)

public:
    Q_INVOKABLE explicit AppNetworkedJsonModel(QObject *parent = nullptr);
    AppNetworkedJsonModel(QString url, const JsonModelColumnList &columns=JsonModelColumnList(), QObject *parent = nullptr, bool usePagination=true);
    AppNetworkedJsonModel(const JsonModelColumnList &columns, QObject *parent = nullptr);

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

    void classBegin() override;
    void componentComplete() override;

    QJsonObject defaultRecord() const;
    void setDefaultRecord(const QJsonObject &newDefaultRecord);

signals:
    void filterChanged(QJsonObject filter);

    void usePaginationChanged();

    void sortKeyChanged();

    void directionChanged();

    void defaultRecordChanged();

protected:
    virtual void onTableRecieved(NetworkResponse *reply);
    void requestData() override;
    Q_INVOKABLE void setSearchQuery(const QString _query);
    Q_INVOKABLE void search();
    Q_INVOKABLE void setFilter(const QJsonObject &filter);
    QJsonObject m_filter;

private:
    QString _query;
    QJsonObject m_oldFilter;

    QString m_direction;

    bool m_usePagination;
    QString m_sortKey=QStringLiteral("id");
    QJsonObject m_defaultRecord;



    Q_PROPERTY(QString sortKey READ sortKey WRITE setSortKey NOTIFY sortKeyChanged)
    Q_PROPERTY(QString direction READ direction WRITE setDirection NOTIFY directionChanged)
    Q_PROPERTY(QJsonObject defaultRecord READ defaultRecord WRITE setDefaultRecord NOTIFY defaultRecordChanged FINAL)
};

#endif // APPNETWORKEDJSONMODEL_H
