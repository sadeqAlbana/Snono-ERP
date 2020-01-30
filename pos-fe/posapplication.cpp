#include "posapplication.h"
#include "mainwindow.h"
#include <QDebug>

PosApplication::PosApplication(int &argc, char **argv) : QApplication(argc, argv)
{
    initSettings();
    //_mainWindow.show();
}

PosApplication::~PosApplication()
{

}

//QWidget *PosApplication::mainWidget()
//{
//    //return &_mainWindow;
//}

void PosApplication::initSettings()
{
    qDebug()<<"init settings";
}
