#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "dialogs/logindialog.h"
#include <QPushButton>
#include "dialogs/adduserdialog.h"
#include <QButtonGroup>
#include <models/jsonModel/jsonmodel.h>
#include <models/jsonModel/networkedjsonmodel.h>
#include <QActionGroup>
#include "gui/tabs/itemstab.h"
#include "gui/tabs/cashiertab.h"
#include "gui/tabs/userstab.h"
#include "gui/tabs/debugtab.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->hide();
    loginDialog=new LoginDialog(this);
    //connect(loginDialog,&LoginDialog::loggedIn,this,&MainWindow::onLoggedIn);
        setupLauncher();
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::onLoggedIn()
{
    setupLauncher();
    //connect(ui->actionExit,&QAction::triggered,this,&MainWindow::close);
}



void MainWindow::setupLauncher()
{
    launcherActionGroup=new QActionGroup(this);
    launcherActionGroup->addAction(ui->actionCashier);
    launcherActionGroup->addAction(ui->actionUsers);
    launcherActionGroup->addAction(ui->actionItems);
    launcherActionGroup->addAction(ui->actionDebug);


    ItemsTab *itemsTab=new ItemsTab();
    CashierTab *cashierTab=new CashierTab();
    UsersTab *usersTab=new UsersTab();
    DebugTab *debugTab=new DebugTab();
    keys.insert(ui->actionItems,itemsTab);
    keys.insert(ui->actionCashier,cashierTab);
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

