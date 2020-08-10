#include "accountingtab.h"
#include "ui_accountingtab.h"
#include <QUrl>
#include "models/accountsmodel.h"
#include "gui/delegates/doublespinboxdelegate.h"
#include <QInputDialog>
#include "messageservice.h"
#include <QJsonObject>
AccountingTab::AccountingTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::AccountingTab)
{
    ui->setupUi(this);
    //ui->quickWidget->setSource(QUrl::fromLocalFile("/tmp/main.qml"));
    model=new AccountsModel(this);
    ui->tableView->setModel(model);
    ui->tableView->setItemDelegateForColumn(2,new DoubleSpinBoxDelegate);

    connect(model,&AccountsModel::depositCashResponseReceived,this,&AccountingTab::onDepositCashResponse);

}

AccountingTab::~AccountingTab()
{
    delete ui;
}

void AccountingTab::on_depositCashButon_clicked()
{
    bool ok=false;
    double amount=QInputDialog::getDouble(this,"Enter Deposit Amount","Amount",1000,1,2147483647,0,&ok);

    if(ok){
        model->depositCash(11,amount);
    }
}

void AccountingTab::onDepositCashResponse(QJsonObject res)
{
    MessageService::information("Deposit Cash",res["message"].toString());
    model->refresh();
}
