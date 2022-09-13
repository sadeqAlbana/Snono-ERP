#include "adduserdialog.h"
#include "ui_adduserdialog.h"
#include <QMessageBox>
AddUserDialog::AddUserDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AddUserDialog)
{
    ui->setupUi(this);
    //ui->userLineEdit->setClearButtonEnabled(true);
    ui->userLineEdit->addAction(QIcon(":/icons/color/icons8-person-96.png"),QLineEdit::LeadingPosition);
    ui->passwordLineEdit->addAction(QIcon(":/icons/color/icons8-password-96.png"),QLineEdit::LeadingPosition);
    ui->confirmPasswordLineEdit->addAction(QIcon(":/icons/color/icons8-password-96.png"),QLineEdit::LeadingPosition);
    //connect(ui->addUserButton,&QToolButton::clicked,this,&AddUserDialog::onAddUserButtonClicked);
    show();
}

AddUserDialog::~AddUserDialog()
{
    delete ui;
}



