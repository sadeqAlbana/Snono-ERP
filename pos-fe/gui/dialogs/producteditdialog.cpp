#include "producteditdialog.h"
#include "ui_producteditdialog.h"
#include <QDebug>
ProductEditDialog::ProductEditDialog(QWidget *parent, const QJsonObject &product) :
    QDialog(parent),
    ui(new Ui::ProductEditDialog)
{
    ui->setupUi(this);

    original=product;
    data=original;
    qDebug()<<data;
    ui->costLE->setText(QString::number(product["default_cost"].toInt()));
    ui->nameLE->setText(product["name"].toString());
    ui->barcodeLE->setText(QString::number(product["barcode"].toInt()));
    ui->sellPriceLE->setText(QString::number(product["list_price"].toInt()));
    ui->quantityLE->setText(product["products_stocks"].toObject()["qty"].toString());
}

ProductEditDialog::~ProductEditDialog()
{
    delete ui;
}

void ProductEditDialog::init(QWidget *parent, const QJsonObject &product)
{
    ProductEditDialog *dlg=new ProductEditDialog(parent,product);
    dlg->setModal(true);
    dlg->exec();
}
