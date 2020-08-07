#include "orderdialog.h"
#include "ui_orderdialog.h"
#include <QJsonObject>
#include <QJsonArray>
#include "gui/delegates/doublespinboxdelegate.h"
#include "utils.h"
OrderDialog::OrderDialog(const QJsonObject &order, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::OrderDialog),
    model(order["pos_order_items"].toArray(),this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);

   ui->tableView->setItemDelegateForColumn(2,new DoubleSpinBoxDelegate);
   ui->tableView->setItemDelegateForColumn(3,new DoubleSpinBoxDelegate);
   ui->tableView->setItemDelegateForColumn(4,new DoubleSpinBoxDelegate);

    ui->reference->setText(order["reference"].toString());
    ui->date->setText(order["date"].toString());
    ui->paidAmount->setText(Currency::formatString(order["paid_amount"].toDouble()));
    ui->returnAmount->setText(Currency::formatString(order["returned_amount"].toDouble()));
    ui->total->setText(Currency::formatString(order["total"].toDouble()));
    ui->taxAmount->setText(Currency::formatString(order["tax_amount"].toDouble()));
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
