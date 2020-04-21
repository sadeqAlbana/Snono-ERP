#ifndef MAKEPAYMENTDIALOG_H
#define MAKEPAYMENTDIALOG_H

#include <QDialog>
#include <datamodels/transaction.h>
namespace Ui {
class MakePaymentDialog;
}

class MakePaymentDialog : public QDialog
{
    Q_OBJECT

public:
    explicit MakePaymentDialog(const double total, double &paid, double &change, QWidget *parent);
    ~MakePaymentDialog();

    static bool init(const double total, double &paid, double &change, QWidget *parent);
    bool isOk(){return _ok;}
    void onPaidSpinBoxValueChange(double value);

private:
    Ui::MakePaymentDialog *ui;
    bool _ok=false;
    const double _total;
    double &_paid;
    double &_change;
};

#endif // MAKEPAYMENTDIALOG_H
