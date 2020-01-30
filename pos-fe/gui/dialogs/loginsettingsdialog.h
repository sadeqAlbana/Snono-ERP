#ifndef LOGINSETTINGSDIALOG_H
#define LOGINSETTINGSDIALOG_H

#include <QDialog>
#include "possettings.h"
namespace Ui {
class LoginSettingsDialog;
}

class LoginSettingsDialog : public QDialog
{
    Q_OBJECT

public:
    explicit LoginSettingsDialog(QWidget *parent = nullptr);
    void onSaveButtonClticked();
    ~LoginSettingsDialog();
    static void showDialog(QWidget *parent);
private:
    Ui::LoginSettingsDialog *ui;
    PosSettings settings;
};

#endif // LOGINSETTINGSDIALOG_H
