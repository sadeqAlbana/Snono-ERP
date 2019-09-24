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
    void onConnectButtonClicked();
    void onLoginButoonClicked();
    void onSettingsButtonClicked();
    void onConnected();
    QString md5(QString clearPassword);

public slots:

signals:
    void loggedIn();


private:
    Ui::LoginDialog *ui;

};

#endif // LOGINDIALOG_H
