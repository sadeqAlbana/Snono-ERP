#include "debugtab.h"
#include "ui_debugtab.h"
DebugTab::DebugTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DebugTab),model(new JournalEntryItemsModel(this))
{
    ui->setupUi(this);
    ui->tableView->setModel(model);
    connect(ui->refreshButton_2,&QToolButton::clicked,this,[this](){
        this->model->refresh();
    });

}

DebugTab::~DebugTab()
{
    delete ui;
}

