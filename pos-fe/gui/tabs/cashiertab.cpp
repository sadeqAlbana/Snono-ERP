#include "cashiertab.h"
#include "ui_cashiertab.h"
#include <models/cashiermodel.h>
#include "gui/dialogs/makepaymentdialog.h"
#include <QMessageBox>
#include <datamodels/transaction.h>
#include "gui/views/searchheaderview.h"

CashierTab::CashierTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CashierTab)
{
    ui->setupUi(this);

    setupView();
    connectSignals();

    //connect(ui->BarcodeLE,&QLineEdit::returnPressed,this,&CashierTab::insertItem);
    //connect(ui->proceedButton,&QToolButton::clicked,this,&CashierTab::makeTransaction);
    //connect(ui->cancelButton,&QToolButton::clicked,this,&CashierTab::cancelTransaction);
    //connect(model,&CashierModel::totalChanged,ui->lcdNumber,static_cast<void(QLCDNumber::*)(double)>(&QLCDNumber::display));

    //ui->tableView->setHorizontalHeader(new SearchHeaderView(model,ui->tableView));
}

CashierTab::~CashierTab()
{
    delete ui;
}

void CashierTab::setupView()
{
    model=new CashierModel(this);
    ui->tableView->setModel(model);
    QByteArray state=settings.value("headerStates/cashier").toByteArray();
    if(!state.isEmpty())
        ui->tableView->horizontalHeader()->restoreState(state);
}

void CashierTab::connectSignals()
{
    connect(QApplication::instance(),&QApplication::aboutToQuit,this,&CashierTab::onAboutToQuit);
}


void CashierTab::onAboutToQuit()
{
    settings.setValue("headerStates/cashier",ui->tableView->horizontalHeader()->saveState());

}

