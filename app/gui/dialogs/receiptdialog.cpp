#include "receiptdialog.h"
#include "ui_receiptdialog.h"

ReceiptDialog::ReceiptDialog(QWidget *parent, const QString &receipt) :
    QDialog(parent),
    ui(new Ui::ReceiptDialog)
{
    ui->setupUi(this);
    ui->textBrowser->setHtml(receipt);
    connect(ui->closeButton,&QToolButton::clicked,this,&ReceiptDialog::close);
}

ReceiptDialog::~ReceiptDialog()
{
    delete ui;
}

void ReceiptDialog::init(QWidget *parent, const QString &receipt)
{
    ReceiptDialog *dlg=new ReceiptDialog(parent,receipt);
    dlg->exec();
}
