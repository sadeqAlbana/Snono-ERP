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
    explicit MakePaymentDialog(Transaction &transaction, QWidget *parent);
    ~MakePaymentDialog();

    static bool init(Transaction &transaction, QWidget *parent);
    bool isOk(){return _ok;}

private:
    Ui::MakePaymentDialog *ui;
    bool _ok=false;
};

#endif // MAKEPAYMENTDIALOG_H
