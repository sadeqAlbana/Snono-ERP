#include "userstab.h"
#include "ui_userstab.h"
#include <models/jsonModel/jsonmodel.h>
#include <models/jsonModel/networkedjsonmodel.h>
#include <QToolButton>
#include <dialogs/adduserdialog.h>
UsersTab::UsersTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::UsersTab)
{
    ui->setupUi(this);


}

UsersTab::~UsersTab()
{
    delete ui;
}


