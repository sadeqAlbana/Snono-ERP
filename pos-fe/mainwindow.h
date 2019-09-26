#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include <QMainWindow>

#include <QActionGroup>
#include <QSettings>
class LoginDialog;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    QMap<QAction *,QWidget *> keys;
    void onLoggedIn();


private:
    Ui::MainWindow *ui;
    LoginDialog *loginDialog;
    QActionGroup *launcherActionGroup;
    void setupLauncher();
    QSettings settings;
};

#endif // MAINWINDOW_H
