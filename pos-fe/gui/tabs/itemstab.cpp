#include "itemstab.h"
#include "ui_itemstab.h"
ItemsTab::ItemsTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ItemsTab)
{
    ui->setupUi(this);
    //ui->tableView->setModel(model);
}

ItemsTab::~ItemsTab()
{
    delete ui;
}

