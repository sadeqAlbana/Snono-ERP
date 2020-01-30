#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "gui/dialogs/logindialog.h"
#include <QPushButton>
#include "gui/dialogs/adduserdialog.h"
#include <QButtonGroup>
#include <models/jsonModel/jsonmodel.h>
#include <models/jsonModel/networkedjsonmodel.h>
#include <QActionGroup>
#include "gui/tabs/itemstab.h"
#include "gui/tabs/cashiertab.h"
#include "gui/tabs/userstab.h"
#include "gui/tabs/debugtab.h"
#include <authmanager.h>
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
    launcherActionGroup->addAction(ui->actionItems);
    launcherActionGroup->addAction(ui->actionDebug);

    CashierTab *cashierTab=new CashierTab();
    ItemsTab *itemsTab=new ItemsTab();
    UsersTab *usersTab=new UsersTab();
    DebugTab *debugTab=new DebugTab();
        keys.insert(ui->actionCashier,cashierTab);
    keys.insert(ui->actionItems,itemsTab);
    keys.insert(ui->actionUsers,usersTab);
    keys.insert(ui->actionDebug,debugTab);
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

