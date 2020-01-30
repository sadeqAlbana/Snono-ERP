#include "userstab.h"
#include "ui_userstab.h"
#include <models/jsonModel/jsonmodel.h>
#include <models/jsonModel/networkedjsonmodel.h>
#include <QToolButton>
#include <gui/dialogs/adduserdialog.h>
UsersTab::UsersTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::UsersTab)
{
    ui->setupUi(this);
    model=new NetworkedJsonModel("/users",this);
    ui->tableView->setModel(model);
    model->requestData();

}

UsersTab::~UsersTab()
{
    delete ui;
    delete model;
}


