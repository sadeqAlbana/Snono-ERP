#include "logindialog.h"
#include "ui_logindialog.h"
//#include "network/router.h"
#include <QCryptographicHash>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <authmanager.h>
LoginDialog::LoginDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LoginDialog)
{
    ui->setupUi(this);
    ui->AddresslineEdit->addAction(QIcon(":/icons/color/icons8-website-96.png"),QLineEdit::LeadingPosition);
    ui->userLineEdit->addAction(QIcon(":/icons/color/icons8-person-96.png"),QLineEdit::LeadingPosition);
    ui->passwordLineEdit->addAction(QIcon(":/icons/color/icons8-password-96.png"),QLineEdit::LeadingPosition);

    connect(ui->settingsButton,&QPushButton::clicked,this,&LoginDialog::onSettingsButtonClicked);
    connect(ui->loginButoon,&QPushButton::clicked,this,&LoginDialog::onLoginButoonClicked);

    connect(AuthManager::instance(),&AuthManager::loggedIn,this,&LoginDialog::onLoggedIn);
    connect(AuthManager::instance(),&AuthManager::invalidCredentails,this,&LoginDialog::onInvalidCredentails);

    this->show();
}

LoginDialog::~LoginDialog()
{
    delete ui;
}

void LoginDialog::onLoginButoonClicked()
{
    AuthManager::instance()->authenticate(ui->userLineEdit->text(),ui->passwordLineEdit->text());
}

void LoginDialog::onSettingsButtonClicked()
{

}

void LoginDialog::onInvalidCredentails()
{
    ui->credentialsLabel->setText(tr("Invalid Credentails"));
}

void LoginDialog::onLoggedIn()
{
    ui->credentialsLabel->clear();
}

