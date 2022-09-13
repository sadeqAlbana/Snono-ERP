#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "gui/dialogs/logindialog.h"
#include <QPushButton>
#include "gui/dialogs/adduserdialog.h"
#include <QButtonGroup>
#include <jsonmodel.h>
#include <models/appnetworkedjsonmodel.h>
#include <QActionGroup>
#include "gui/tabs/itemstab.h"
#include "gui/tabs/cashiertab.h"
#include "gui/tabs/userstab.h"
#include "gui/tabs/debugtab.h"
#include "gui/tabs/productstab.h"
#include "gui/tabs/accountingtab.h"
#include <authmanager.h>
#include "gui/dialogs/producteditdialog.h"
#include "messageservice.h"
#include "gui/tabs/orderstab.h"
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->hide();
    loginDialog=new LoginDialog(this);
    connect(AuthManager::instance(),&AuthManager::loggedIn,this,&MainWindow::onLoggedIn);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::onLoggedIn()
{
    MessageService::setMainWidget(this);
    loginDialog->hide();
    setupLauncher();
    this->show();
    connect(ui->actionExit,&QAction::triggered,this,&MainWindow::close);
}

void MainWindow::setupLauncher()
{
    launcherActionGroup=new QActionGroup(this);
    launcherActionGroup->addAction(ui->actionCashier);
    launcherActionGroup->addAction(ui->actionUsers);
    launcherActionGroup->addAction(ui->actionOrders);
    launcherActionGroup->addAction(ui->actionProducts);
    launcherActionGroup->addAction(ui->actionDebug);
    launcherActionGroup->addAction(ui->actionAccounting);

    CashierTab *cashierTab=new CashierTab();
    OrdersTab *ordersTab=new OrdersTab();
    UsersTab *usersTab=new UsersTab();
    DebugTab *debugTab=new DebugTab();
    ProductsTab *productsTab= new ProductsTab();
    AccountingTab *accountingTab=new AccountingTab();

    keys.insert(ui->actionCashier,cashierTab);
    keys.insert(ui->actionOrders,ordersTab);
    keys.insert(ui->actionUsers,usersTab);
    keys.insert(ui->actionDebug,debugTab);
    keys.insert(ui->actionProducts,productsTab);
    keys.insert(ui->actionAccounting,accountingTab);
    ui->tabWidget->addTab(cashierTab,ui->actionCashier->icon(),ui->actionCashier->text());
    connect(ui->tabWidget,&QTabWidget::tabCloseRequested,ui->tabWidget,&QTabWidget::removeTab);
    connect(launcherActionGroup,
            &QActionGroup::triggered,
             [=](QAction *action){
                            if(keys.contains(action))
                            {
                                if(ui->tabWidget->indexOf(keys.value(action))==-1)
                                        ui->tabWidget->addTab(keys.value(action),action->icon(),action->text());

                                ui->tabWidget->setCurrentWidget(keys.value(action));
                            }
                        });
}

