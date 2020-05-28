#include "productstab.h"
#include "ui_productstab.h"
#include "gui/dialogs/producteditdialog.h"
#include "messageservice.h"
ProductsTab::ProductsTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProductsTab), model(this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);
    connect(ui->tableView,&QTableView::doubleClicked,this,&ProductsTab::onTableviewDoubleClicked);
    ui->tableView->horizontalHeader()->setFixedHeight(55);
    connect(&model,&ProductsModel::productUpdateReply,this,&ProductsTab::onProductUpdateReply);
}

ProductsTab::~ProductsTab()
{
    delete ui;
}

void ProductsTab::onTableviewDoubleClicked(const QModelIndex &index)
{
    if(!index.isValid())
        return;

    QJsonObject product= ProductEditDialog::init(this,model.data(index.row()));
    if(!product.isEmpty())
        model.updateProduct(product);
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
