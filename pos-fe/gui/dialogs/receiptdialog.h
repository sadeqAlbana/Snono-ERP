#ifndef RECEIPTDIALOG_H
#define RECEIPTDIALOG_H

#include <QDialog>
class QTextDocument;
namespace Ui {
class ReceiptDialog;
}

class ReceiptDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ReceiptDialog(QWidget *parent, const QString &receipt);
    ~ReceiptDialog();
    static void init(QWidget *parent,const QString &receipt);

private:
    Ui::ReceiptDialog *ui;
};

#endif // RECEIPTDIALOG_H
