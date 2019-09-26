#ifndef POSAPPLICATION_H
#define POSAPPLICATION_H

#include <QApplication>
#include <QSettings>
class MainWindow;
class PosApplication : public QApplication
{
public:
    PosApplication(int &argc, char **argv);
    static QWidget *mainWidget();

private:
    QSettings settings;
    void initSettings();
    static MainWindow *_mainWindow;

};

#endif // POSAPPLICATION_H
