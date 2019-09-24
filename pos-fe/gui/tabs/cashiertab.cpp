#include "cashiertab.h"
#include "ui_cashiertab.h"
#include <models/cashiermodel.h>
#include "dialogs/makepaymentdialog.h"
#include <QMessageBox>
#include <datamodels/transaction.h>
#include "gui/views/searchheaderview.h"
CashierTab::CashierTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CashierTab)
{
    ui->setupUi(this);
    model=new CashierModel(this);
    ui->tableView->setModel(model);
    //connect(ui->BarcodeLE,&QLineEdit::returnPressed,this,&CashierTab::insertItem);
    //connect(ui->proceedButton,&QToolButton::clicked,this,&CashierTab::makeTransaction);
    //connect(ui->cancelButton,&QToolButton::clicked,this,&CashierTab::cancelTransaction);
    //connect(model,&CashierModel::totalChanged,ui->lcdNumber,static_cast<void(QLCDNumber::*)(double)>(&QLCDNumber::display));

    ui->tableView->setHorizontalHeader(new SearchHeaderView(model,ui->tableView));

}

CashierTab::~CashierTab()
{
    delete ui;
}

