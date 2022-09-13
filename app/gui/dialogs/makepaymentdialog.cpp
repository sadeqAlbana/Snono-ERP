#include "makepaymentdialog.h"
#include "ui_makepaymentdialog.h"

MakePaymentDialog::MakePaymentDialog(const double total, double &paid, double &change, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::MakePaymentDialog),_total(total),_paid(paid),_change(change)
{
    ui->setupUi(this);
    setModal(true);
    ui->totalLE->setText(QString::number(total));
    ui->paidSpinBox->setValue(total);
    _paid=ui->paidSpinBox->value();
    ui->paidSpinBox->setMinimum(total);
    ui->changeLE->setText(QStringLiteral("0"));
    connect(ui->cancelButton,&QToolButton::clicked,this,&MakePaymentDialog::close);
    connect(ui->payButton,&QToolButton::clicked,[&](){_ok=true;close();});
    connect(ui->paidSpinBox,
            static_cast<void(QDoubleSpinBox::*)(double)>(&QDoubleSpinBox::valueChanged),
            this,&MakePaymentDialog::onPaidSpinBoxValueChange);

}

MakePaymentDialog::~MakePaymentDialog()
{
    delete ui;
}

bool MakePaymentDialog::init(const double total,double &paid,double &change, QWidget *parent)
{
    MakePaymentDialog *dlg=new MakePaymentDialog(total,paid,change, parent);
    dlg->exec();
    bool ok=dlg->isOk();
    delete dlg;
    return ok;
}

void MakePaymentDialog::onPaidSpinBoxValueChange(double value)
{
    _paid=value;
    _change=value-_total;
    ui->changeLE->setText(QString::number(_change));
}
