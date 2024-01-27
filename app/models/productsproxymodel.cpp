#include "productsproxymodel.h"
#include "productsmodel.h"
#include <QTimer>
ProductsProxyModel::ProductsProxyModel(QObject *parent)
    : TreeProxyModel{parent}
{
    ProductsModel *mdl= new ProductsModel(this);

//    mdl->refresh();

    QTimer::singleShot(10000,[this,mdl](){
        setSourceModel(mdl);


    });

}
