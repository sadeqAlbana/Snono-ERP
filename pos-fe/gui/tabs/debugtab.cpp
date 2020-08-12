#include "debugtab.h"
#include "ui_debugtab.h"
#include "gui/delegates/doublespinboxdelegate.h"
DebugTab::DebugTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DebugTab),model(new JournalEntryItemsModel(this))
{
    ui->setupUi(this);
    ui->tableView->setModel(model);
    connect(ui->refreshButton_2,&QToolButton::clicked,this,[this](){
        this->model->refresh();
    });

    ui->tableView->setItemDelegateForColumn(5,new DoubleSpinBoxDelegate);
    ui->tableView->setItemDelegateForColumn(6,new DoubleSpinBoxDelegate);

}

DebugTab::~DebugTab()
{
    delete ui;
}

