#include "productstab.h"
#include "ui_productstab.h"

ProductsTab::ProductsTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProductsTab), model(this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);
}

ProductsTab::~ProductsTab()
{
    delete ui;
}
