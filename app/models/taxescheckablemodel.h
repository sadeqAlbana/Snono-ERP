#ifndef TAXESCHECKABLEMODEL_H
#define TAXESCHECKABLEMODEL_H

#include <QObject>
#include "jsonModel/checkablelistmodel.h"
class TaxesCheckableModel : public CheckableListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit TaxesCheckableModel(QObject *parent = nullptr);

signals:

};

#endif // TAXESCHECKABLEMODEL_H
