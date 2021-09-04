#include "checkablelistdialog.h"
#include "ui_checkablelistdialog.h"

CheckableListDialog::CheckableListDialog(const QString &displayColumn, const QString &dataColumn, QSet<int> original, const QString &url, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CheckableListDialog)
{
    ui->setupUi(this);
    connect(ui->buttonBox,&QDialogButtonBox::accepted,this,&CheckableListDialog::onAccepted);
    connect(ui->buttonBox,&QDialogButtonBox::rejected,this,&CheckableListDialog::close);
    model=new CheckableListModel(displayColumn,dataColumn,original,url,this);
    ui->tableView->setModel(model);
    //model->requestData();
}

CheckableListDialog::~CheckableListDialog()
{
    delete ui;
}

QJsonArray CheckableListDialog::init(const QString &title, const QString &displayColumn, const QString &dataColumn, QSet<int> original, const QString &url, QWidget *parent)
{
    CheckableListDialog *dlg=new CheckableListDialog(displayColumn,dataColumn,original,url,parent);
    dlg->setWindowTitle(title);

    bool exec=dlg->exec();
    qDebug()<<exec;
    if(exec){
        return dlg->returnData;
    }
    return QJsonArray();
}

void CheckableListDialog::onAccepted()
{
    returnData=model->selectedRows();
}

