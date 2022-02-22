#ifndef CATEGORIESMODEL_H
#define CATEGORIESMODEL_H

#include <QObject>
#include "appnetworkedjsonmodel.h"
class CategoriesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit CategoriesModel(QObject *parent = nullptr);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;


    //network requests
signals:

};

#endif // CATEGORIESMODEL_H
