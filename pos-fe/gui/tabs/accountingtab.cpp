#include "accountingtab.h"
#include "ui_accountingtab.h"

AccountingTab::AccountingTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::AccountingTab)
{
    ui->setupUi(this);
}

AccountingTab::~AccountingTab()
{
    delete ui;
}
