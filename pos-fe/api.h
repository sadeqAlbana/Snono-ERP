#ifndef API_H
#define API_H

#include <QObject>
#include <QJsonObject>
//this class will be used to make all  api calls in the future !
class Api : public QObject
{
    Q_OBJECT
public:
    explicit Api(QObject *parent = nullptr);
    Q_INVOKABLE void processCustomBill(const QString &name, const int &vendorId,const QJsonArray &items);
signals:
    void processCustomBillResponse(QJsonObject reply);

};

#endif // API_H
