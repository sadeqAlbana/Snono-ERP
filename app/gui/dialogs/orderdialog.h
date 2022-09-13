#ifndef ORDERDIALOG_H
#define ORDERDIALOG_H

#include <QDialog>
#include "models/orderitemsmodel.h"
namespace Ui {
class OrderDialog;
}

class OrderDialog : public QDialog
{
    Q_OBJECT

public:
    explicit OrderDialog(const QJsonObject &order,QWidget *parent = nullptr);
    ~OrderDialog();

    static void init(const QJsonObject &order,QWidget *parent);

private:
    Ui::OrderDialog *ui;
    OrderItemsModel model;

};

#endif // ORDERDIALOG_H
