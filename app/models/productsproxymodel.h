#ifndef PRODUCTSPROXYMODEL_H
#define PRODUCTSPROXYMODEL_H

#include <treeproxymodel.h>
#include <QQmlEngine>

class ProductsProxyModel : public TreeProxyModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ProductsProxyModel(QObject *parent = nullptr);
};

#endif // PRODUCTSPROXYMODEL_H
