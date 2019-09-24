#include "transaction.h"

Transaction::Transaction(qreal Total, qreal Paid, qreal Change, QJsonArray Data)
{
    setTotal(Total);
    setPaid(Paid);
    setChange(Change);
    setData(Data);
}

QJsonObject Transaction::info()
{
    return QJsonObject{
      {"total",total()},
      {"paid",paid()},
      {"change",change()},
      {"data",data()}
    };
}
