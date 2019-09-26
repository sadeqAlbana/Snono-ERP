#include "posapplication.h"
#include "mainwindow.h"

MainWindow *PosApplication::_mainWindow;

PosApplication::PosApplication(int &argc, char **argv) : QApplication(argc, argv)
{
    initSettings();
    _mainWindow=new MainWindow();
}

QWidget *PosApplication::mainWidget()
{
    return _mainWindow;
}

void PosApplication::initSettings()
{

}
