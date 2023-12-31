#include "productstab.h"
#include "ui_productstab.h"
#include "gui/dialogs/producteditdialog.h"
#include "messageservice.h"
#include "gui/dialogs/checkablelistdialog.h"
#include <QMenu>
#include <QInputDialog>
#include "gui/delegates/doublespinboxdelegate.h"
ProductsTab::ProductsTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProductsTab), model(this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);
    connect(ui->tableView,&QTableView::doubleClicked,this,&ProductsTab::onTableviewDoubleClicked);
    ui->tableView->horizontalHeader()->setFixedHeight(55);
    connect(&model,&ProductsModel::productUpdateReply,this,&ProductsTab::onProductUpdateReply);
    connect(&model,&ProductsModel::productQuantityUpdated,this,&ProductsTab::onProductQuantityUpdate);
    connect(&model,&ProductsModel::stockPurchasedReply,this,&ProductsTab::onProductQuantityUpdate);
    connect(ui->tableView,&QTableView::customContextMenuRequested,
            this,&ProductsTab::onContextMenuRequested);


    ui->tableView->setItemDelegateForColumn(3,new DoubleSpinBoxDelegate);
    ui->tableView->setItemDelegateForColumn(5,new DoubleSpinBoxDelegate);
}

ProductsTab::~ProductsTab()
{
    delete ui;
}

void ProductsTab::onTableviewDoubleClicked(const QModelIndex &index)
{
    if(!index.isValid())
        return;

    editSelectedProduct();
}

void ProductsTab::onProductUpdateReply(QJsonObject reply)
{
    if(!reply["status"].toBool()){
        MessageService::warning("Error updating product",reply["message"].toString());
    }
    else{
        MessageService::information("success","product updated successfully");
    }
}

void ProductsTab::onContextMenuRequested(const QPoint &pos)
{
    QModelIndex index=ui->tableView->indexAt(pos);



    QMenu menu; //create menu

    menu.addAction(tr("&New Product"),this,&ProductsTab::addProduct);
    menu.addAction(tr("&Refresh"),&model,&ProductsModel::refresh);
    if(index.isValid()){
        menu.addAction(tr("&Edit"),this,&ProductsTab::editSelectedProduct);
        menu.addAction(tr("&Edit Taxes"),this,&ProductsTab::editSelectedProductTaxes);
        menu.addAction(tr("&update Quantity"),this,&ProductsTab::updateSelectedQuantity);
        menu.addAction(tr("&Purchase Stock"),this,&ProductsTab::purchaseStock);
    }

    menu.exec(ui->tableView->viewport()->mapToGlobal(pos));
}

void ProductsTab::addProduct()
{

}

void ProductsTab::editSelectedProduct()
{
    QModelIndex index=ui->tableView->currentIndex();
    QJsonObject product= ProductEditDialog::init(this,model.jsonObject(index.row()));
    if(!product.isEmpty())
        model.updateProduct(product);
}

void ProductsTab::editSelectedProductTaxes()
{
    QModelIndex index=ui->tableView->currentIndex();

    QJsonObject product=model.jsonObject(index.row());
    QSet<int> ids;
    for(QJsonValue value : product["taxes"].toArray())
        ids<< value.toObject().value("id").toInt();

    QJsonArray taxes= CheckableListDialog::init("Edit Taxes","name","id",ids, "/taxes",this);
    if(taxes!=product["taxes"].toArray()){
        product["taxes"]=taxes;
        model.updateProduct(product);
    }
}

void ProductsTab::updateSelectedQuantity()
{
    QModelIndex index=ui->tableView->currentIndex();

    QJsonObject product=model.jsonObject(index.row());
    double stock=product["products_stocks"].toObject()["qty"].toDouble();

    double newStock=QInputDialog::getDouble(this,tr("Update Quantity"),tr("Enter new Quantity"),stock);

    if(newStock!=stock)
        model.updateProductQuantity(index.row(),newStock);
}

void ProductsTab::purchaseStock()
{
    QModelIndex index=ui->tableView->currentIndex();

    QJsonObject product=model.jsonObject(index.row());
    bool ok=false;
    double qty=QInputDialog::getDouble(this,tr("Purchase Stock"),tr("Enter a Quantity"),1,1,9999,2,&ok);

    //if(ok)
        //model.purchaseStock(index.row(),qty);
}

void ProductsTab::onProductQuantityUpdate(QJsonObject reply)
{
    if(reply["status"].toBool()){
        MessageService::information("success","product Quantity updated successfully");
        model.refresh();

    }
    else{
        MessageService::warning(tr("Error updating Quantity"),reply["message"].toString());
    }
}

void ProductsTab::onStockPurchase(QJsonObject reply)
{
    if(reply["status"].toBool()){
        MessageService::information("success","Stock Purchased Successfully");
        model.refresh();

    }
    else{
        MessageService::warning(tr("Error updating Quantity"),reply["message"].toString());
    }
}
