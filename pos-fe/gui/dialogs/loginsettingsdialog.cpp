#include "loginsettingsdialog.h"
#include "ui_loginsettingsdialog.h"
#include <QDoubleValidator>
#include <QUrl>
LoginSettingsDialog::LoginSettingsDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LoginSettingsDialog)
{
    ui->setupUi(this);
    //ui->serverPortLE->setValidator(new QRegExpValidator(QRegExp("[1-65535]"), this) );
    connect(ui->cancelButton,&QToolButton::clicked,this,&LoginSettingsDialog::close);
    connect(ui->saveButton,&QToolButton::clicked,this,&LoginSettingsDialog::onSaveButtonClticked);

    QUrl url=settings.serverUrl();
    ui->serverAddressLE->setText(url.host());
    ui->serverPortLE->setText(QString::number(url.port()));
    ui->sslCB->setChecked(url.scheme() == "https" ? true: false);

}

void LoginSettingsDialog::onSaveButtonClticked()
{
    QUrl url;
    settings.setServerUrl(ui->serverPortLE->text(),ui->serverPortLE->text().toInt(),ui->sslCB->isChecked());
    close();
}

LoginSettingsDialog::~LoginSettingsDialog()
{
    delete ui;
}

void LoginSettingsDialog::showDialog(QWidget *parent)
{
    LoginSettingsDialog d(parent);
    d.show();
    d.exec();
}
