#include "messageservice.h"
#include <QMessageBox>
QWidget *MessageService::_mainWidget;


void MessageService::about(const QString &title, const QString &text)
{
    QMessageBox::about(_mainWidget,title,text);
}

QMessageBox::StandardButton MessageService::critical(const QString &title, const QString &text, QMessageBox::StandardButtons buttons, QMessageBox::StandardButton defaultButton)
{
    return QMessageBox::critical(_mainWidget,title,text,buttons);
}

QMessageBox::StandardButton MessageService::information(const QString &title, const QString &text, QMessageBox::StandardButtons buttons, QMessageBox::StandardButton defaultButton)
{
    return QMessageBox::information(_mainWidget,title,text,buttons);
}

QMessageBox::StandardButton MessageService::question(const QString &title, const QString &text, QMessageBox::StandardButtons buttons, QMessageBox::StandardButton defaultButton)
{
    return QMessageBox::question(_mainWidget,title,text,buttons);
}

QMessageBox::StandardButton MessageService::warning(const QString &title, const QString &text, QMessageBox::StandardButtons buttons, QMessageBox::StandardButton defaultButton)
{
    return QMessageBox::warning(_mainWidget,title,text,buttons);
}

void MessageService::setMainWidget(QWidget *widget)
{
    _mainWidget=widget;
}
