#include "makepaymentdialog.h"
#include "ui_makepaymentdialog.h"

MakePaymentDialog::MakePaymentDialog(Transaction &transaction, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::MakePaymentDialog)
{
    ui->setupUi(this);
    setModal(true);
    ui->totalSpinBox->setValue(transaction.total());
    ui->paidSpinBox->setValue(transaction.paid());
    ui->changeSpinBox->setValue(transaction.change());
    connect(ui->cancelButton,&QToolButton::clicked,this,&MakePaymentDialog::close);
    connect(ui->payButton,&QToolButton::clicked,[&](){_ok=true;close();});

}

MakePaymentDialog::~MakePaymentDialog()
{
    delete ui;
}

bool MakePaymentDialog::init(Transaction &transaction, QWidget *parent)
{
    MakePaymentDialog *dlg=new MakePaymentDialog(transaction, parent);
    dlg->exec();
    bool ok=dlg->isOk();
    if(ok)
    {
        transaction.setTotal(dlg->ui->totalSpinBox->value());
        transaction.setPaid(dlg->ui->paidSpinBox->value());
        transaction.setChange(dlg->ui->changeSpinBox->value());
    }
    delete dlg;
    return ok;
}
