#ifndef PRODUCTSALESREPORTMODEL_H
#define PRODUCTSALESREPORTMODEL_H

#include "appnetworkedjsonmodel.h"
#include <QDate>
class ProductSalesReportModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ProductSalesReportModel(QObject *parent = nullptr);

    const QDate &from() const;
    void setFrom(const QDate &newFrom);

    const QDate &to() const;
    void setTo(const QDate &newTo);
    Q_INVOKABLE bool print();

signals:
    void fromChanged();

    void toChanged();

private:
    QDate m_from;
    QDate m_to;

    Q_PROPERTY(QDate from READ from WRITE setFrom NOTIFY fromChanged)
    Q_PROPERTY(QDate to READ to WRITE setTo NOTIFY toChanged)
};

#endif // PRODUCTSALESREPORTMODEL_H
