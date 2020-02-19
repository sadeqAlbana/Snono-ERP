#ifndef PRODUCTEDITDIALOG_H
#define PRODUCTEDITDIALOG_H

#include <QDialog>

namespace Ui {
class ProductEditDialog;
}

class ProductEditDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ProductEditDialog(QWidget *parent = nullptr);
    ~ProductEditDialog();

private:
    Ui::ProductEditDialog *ui;
};

#endif // PRODUCTEDITDIALOG_H
