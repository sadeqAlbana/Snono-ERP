#include "taxescheckablemodel.h"

TaxesCheckableModel::TaxesCheckableModel(QObject *parent) : CheckableListModel("name","id",QSet<int>(),"/taxes", parent)
{
    requestData();
}
