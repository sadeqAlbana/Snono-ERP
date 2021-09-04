#include "orderstab.h"
#include "ui_orderstab.h"
#include <QMenu>
#include "gui/dialogs/orderdialog.h"
#include "models/orderitemsmodel.h"
#include "gui/dialogs/orderdialog.h"
#include "gui/delegates/doublespinboxdelegate.h"
OrdersTab::OrdersTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::OrdersTab),
    model(this)
{
    ui->setupUi(this);
    ui->tableView->setModel(&model);
    connect(&model,&OrdersModel::dataRecevied,this,&OrdersTab::onDataReceived);
    connect(QApplication::instance(),&QApplication::aboutToQuit,this,&OrdersTab::onAboutToClose);
    connect(ui->tableView,&QTableView::customContextMenuRequested,
            this,&OrdersTab::onContextMenuRequested);
        connect(ui->tableView,&QTableView::doubleClicked,this,&OrdersTab::viewCurrentOrder);

    ui->tableView->setItemDelegateForColumn(3,new DoubleSpinBoxDelegate);
    ui->tableView->setItemDelegateForColumn(5,new DoubleSpinBoxDelegate);
}

OrdersTab::~OrdersTab()
{
    delete ui;
}

void OrdersTab::onTableviewDoubleClicked(const QModelIndex &index)
{
    if(!index.isValid())
        return;

    viewCurrentOrder();
}

void OrdersTab::onContextMenuRequested(const QPoint &pos)
{
    QModelIndex index=ui->tableView->indexAt(pos);



    QMenu menu; //create menu

    menu.addAction(tr("&Refresh"),&model,&OrdersModel::refresh);
    if(index.isValid()){
//        menu.addAction(tr("&Edit"),this,&ProductsTab::editSelectedProduct);
//        menu.addAction(tr("&Edit Taxes"),this,&ProductsTab::editSelectedProductTaxes);
//        menu.addAction(tr("&update Quantity"),this,&ProductsTab::updateSelectedQuantity);
    }

    menu.exec(ui->tableView->viewport()->mapToGlobal(pos));
}

void OrdersTab::viewCurrentOrder()
{
    QModelIndex index=ui->tableView->currentIndex();

    QJsonObject order=model.jsonObject(index.row());
    OrderDialog::init(order,this);
}

void OrdersTab::onDataReceived()
{
    if(settings.contains("table_orders"))
        ui->tableView->horizontalHeader()->restoreState(settings.value("table_orders").toByteArray());
}

void OrdersTab::onAboutToClose()
{
    settings.setValue("table_orders",ui->tableView->horizontalHeader()->saveState());
}
