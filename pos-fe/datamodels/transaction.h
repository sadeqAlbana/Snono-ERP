#ifndef TRANSACTION_H
#define TRANSACTION_H
#include <QJsonObject>
#include <QJsonArray>

class Transaction
{
public:
    Transaction(qreal Total=0, qreal Paid=0, qreal Change=0, QJsonArray Data=QJsonArray());
    qreal paid(){return _paid;}
    qreal total(){return _total;}
    qreal change(){return _change;}
    QJsonArray data(){return _data;}
    void setPaid(qreal Paid){_paid=Paid;}
    void setChange(qreal Change){_change=Change;}
    void setTotal(qreal Total){_total=Total;}
    void setData(QJsonArray Data){_data=Data;}

    QJsonObject info();


private:
    qreal _total;
    qreal _paid;
    qreal _change;
    QJsonArray _data;
};

#endif // TRANSACTION_H
