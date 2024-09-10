#ifndef MONTHLYFINANCEMODEL_H
#define MONTHLYFINANCEMODEL_H

#include <QQmlEngine>
#include <appnetworkedjsonmodel.h>

class MonthlyFinanceModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE explicit MonthlyFinanceModel(QObject *parent = nullptr);
};

#endif // MONTHLYFINANCEMODEL_H
