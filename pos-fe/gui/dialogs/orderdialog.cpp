#include "orderdialog.h"
#include "ui_orderdialog.h"
#include <QJsonObject>
#include <QJsonArray>
OrderDialog::OrderDialog(const QJsonObject &order, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::OrderDialog),
    model(order["pos_order_items"].toArray(),this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);

    ui->reference->setText(order["reference"].toString());
    ui->date->setText(order["date"].toString());
    ui->paidAmount->setText(QString::number(order["paid_amount"].toDouble()));
    ui->returnAmount->setText(QString::number(order["returned_amount"].toDouble()));
    ui->total->setText(QString::number(order["total"].toDouble()));
    ui->taxAmount->setText(QString::number(order["tax_amount"].toDouble()));
    ui->customer->setText(order["customers"].toObject()["name"].toString());
}

OrderDialog::~OrderDialog()
{
    delete ui;
}

void OrderDialog::init(const QJsonObject &order, QWidget *parent)
{
    OrderDialog  *dlg=new OrderDialog(order,parent);
    dlg->exec();
}
