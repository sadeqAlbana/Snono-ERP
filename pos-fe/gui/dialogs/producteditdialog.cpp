#include "producteditdialog.h"
#include "ui_producteditdialog.h"

ProductEditDialog::ProductEditDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ProductEditDialog)
{
    ui->setupUi(this);
}

ProductEditDialog::~ProductEditDialog()
{
    delete ui;
}

void ProductEditDialog::init(QWidget *parent)
{
    ProductEditDialog *dlg=new ProductEditDialog(parent);

    dlg->exec();
}
