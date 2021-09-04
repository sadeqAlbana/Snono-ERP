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
    Q_INVOKABLE void addCategory(const QString &name, const int &parentId);
    Q_INVOKABLE void removeCategory(const int &categoryId);


signals:
    void categoryAddReply(QJsonObject reply);
    void categoryRemoveReply(QJsonObject reply);


};

#endif // CATEGORIESMODEL_H
