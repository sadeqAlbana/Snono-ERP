#ifndef ORDERSTAB_H
#define ORDERSTAB_H

#include <QWidget>
#include "models/ordersmodel.h"
#include <QSettings>
namespace Ui {
class OrdersTab;
}

class OrdersTab : public QWidget
{
    Q_OBJECT

public:
    explicit OrdersTab(QWidget *parent = nullptr);
    ~OrdersTab();
    void onTableviewDoubleClicked(const QModelIndex &index);
    void onContextMenuRequested(const QPoint &pos);

    void viewCurrentOrder();
    void onDataReceived();
    void onAboutToClose();

private:
    Ui::OrdersTab *ui;
    OrdersModel model;
    QSettings settings;
};

#endif // ORDERSTAB_H
