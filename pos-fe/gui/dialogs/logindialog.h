#ifndef LOGINDIALOG_H
#define LOGINDIALOG_H
#include <QDialog>

namespace Ui {
class LoginDialog;
}

class LoginDialog : public QDialog
{
    Q_OBJECT
public:
    explicit LoginDialog(QWidget *parent = nullptr);
    ~LoginDialog();
    //button callbacks
    void onConnectButtonClicked();
    void onLoginButoonClicked();
    void onSettingsButtonClicked();

    void onInvalidCredentails();
    void onLoggedIn();
    QString md5(QString clearPassword);

private:
    Ui::LoginDialog *ui;

};

#endif // LOGINDIALOG_H
