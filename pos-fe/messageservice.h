#ifndef MESSAGESERVICE_H
#define MESSAGESERVICE_H

#include <QMessageBox>
class MessageService
{
public:
     static void about(const QString &title, const QString &text);
     static QMessageBox::StandardButton critical(const QString &title, const QString &text, QMessageBox::StandardButtons buttons = QMessageBox::Ok, QMessageBox::StandardButton defaultButton = QMessageBox::NoButton);
     static QMessageBox::StandardButton information(const QString &title, const QString &text, QMessageBox::StandardButtons buttons = QMessageBox::Ok, QMessageBox::StandardButton defaultButton = QMessageBox::NoButton);
     static QMessageBox::StandardButton question(const QString &title, const QString &text, QMessageBox::StandardButtons buttons = QMessageBox::StandardButtons(QMessageBox::Yes | QMessageBox::No), QMessageBox::StandardButton defaultButton = QMessageBox::NoButton);
     static QMessageBox::StandardButton warning(const QString &title, const QString &text, QMessageBox::StandardButtons buttons = QMessageBox::Ok, QMessageBox::StandardButton defaultButton = QMessageBox::NoButton);
     friend class MainWindow;
     friend class LoginDialog;
private:
    static void setMainWidget(QWidget *widget);
    static QWidget *_mainWidget;
};

#endif // MESSAGESERVICE_H
