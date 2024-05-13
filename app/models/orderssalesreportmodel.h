#ifndef ORDERSSALESREPORTMODEL_H
#define ORDERSSALESREPORTMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>
class OrdersSalesReportModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit OrdersSalesReportModel(QObject *parent = nullptr);
    Q_INVOKABLE bool print(QJsonArray data=QJsonArray(), const QString &from=QString(), const QString &to=QString());

signals:
};

#endif // ORDERSSALESREPORTMODEL_H
