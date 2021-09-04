#include "userstab.h"
#include "ui_userstab.h"
#include "models/usersmodel.h"
#include <QToolButton>
#include <gui/dialogs/adduserdialog.h>
UsersTab::UsersTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::UsersTab)
{
    ui->setupUi(this);
    model=new UsersModel(this);
    ui->tableView->setModel(model);

}

UsersTab::~UsersTab()
{
    delete ui;
    delete model;
}


