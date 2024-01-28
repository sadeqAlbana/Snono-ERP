#include "productsproxymodel.h"
#include "productsmodel.h"
#include <QTimer>
ProductsProxyModel::ProductsProxyModel(QObject *parent)
    : TreeProxyModel{parent}
{
//    ProductsModel *mdl= new ProductsModel(this);
//    mdl->refresh();

//    connect(mdl,&NetworkedJsonModel::dataRecevied,this,[this,mdl]{

//        this->setSourceModel(mdl);

//    });

//    QTimer::singleShot(100,this,[this,mdl](){this->setSourceModel(mdl);});

}
