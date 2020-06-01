#ifndef PRODUCTSTAB_H
#define PRODUCTSTAB_H

#include <QWidget>
#include "models/jsonModel/productsmodel.h"
namespace Ui {
class ProductsTab;
}

class ProductsTab : public QWidget
{
    Q_OBJECT

public:
    explicit ProductsTab(QWidget *parent = nullptr);
    ~ProductsTab();
    void onTableviewDoubleClicked(const QModelIndex &index);
    void onProductUpdateReply(QJsonObject reply);
    void onContextMenuRequested(const QPoint &pos);

    void addProduct();
    void editSelectedProduct();
    void editSelectedProductTaxes();
    void updateSelectedQuantity();
    void onProductQuantityUpdate(QJsonObject reply);

private:
    Ui::ProductsTab *ui;
    ProductsModel model;
};

#endif // PRODUCTSTAB_H
