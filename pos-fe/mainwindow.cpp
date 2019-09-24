#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "loginwidget.h"
#include <QNetworkAccessManager>
#include <QDebug>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->mainToolBar->hide();

    //LoginWidget *loginWidget=new LoginWidget(this);

}

MainWindow::~MainWindow()
{
    delete ui;
}
