#include "productstab.h"
#include "ui_productstab.h"
#include "gui/dialogs/producteditdialog.h"
ProductsTab::ProductsTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProductsTab), model(this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);
    connect(ui->tableView,&QTableView::doubleClicked,this,&ProductsTab::onTableviewDoubleClicked);
    ui->tableView->horizontalHeader()->setFixedHeight(55);
}

ProductsTab::~ProductsTab()
{
    delete ui;
}

void ProductsTab::onTableviewDoubleClicked(const QModelIndex &index)
{
    if(!index.isValid())
        return;

    //QVariant product=

    ProductEditDialog::init(this,model.data(index.row()));
}
