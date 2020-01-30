#ifndef POSAPPLICATION_H
#define POSAPPLICATION_H

#include <QApplication>
#include "mainwindow.h"
#include <QSettings>
class MainWindow;
class PosApplication : public QApplication
{
public:
    PosApplication(int &argc, char **argv);
    ~PosApplication();
    //static QWidget *mainWidget();

private:
    QSettings settings;
    void initSettings();
    MainWindow _mainWindow;

};

#endif // POSAPPLICATION_H
