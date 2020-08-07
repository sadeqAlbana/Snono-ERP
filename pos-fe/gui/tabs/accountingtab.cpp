#include "accountingtab.h"
#include "ui_accountingtab.h"
#include <QUrl>
AccountingTab::AccountingTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::AccountingTab)
{
    ui->setupUi(this);
    //ui->quickWidget->setSource(QUrl::fromLocalFile("/tmp/main.qml"));
}

AccountingTab::~AccountingTab()
{
    delete ui;
}
