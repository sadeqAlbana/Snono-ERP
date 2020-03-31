#include "cashiertab.h"
#include "ui_cashiertab.h"
#include <models/cashiermodel.h>
#include "gui/dialogs/makepaymentdialog.h"
#include <QMessageBox>
#include <datamodels/transaction.h>
#include "gui/views/searchheaderview.h"
#include "gui/delegates/doublespinboxdelegate.h"
#include <QLocale>
#include <QtMath>
#include "utils/numbereditor.h"
CashierTab::CashierTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CashierTab)
{
    ui->setupUi(this);

    setupView();
    connectSignals();
}

CashierTab::~CashierTab()
{
    delete ui;
}

void CashierTab::setupView()
{
    model=new CashierModel(this);

    ui->tableView->setModel(model);
    ui->tableView->horizontalHeader()->setFixedHeight(55);
    //settings.remove("headerStates/cashier");
    QByteArray state=settings.value("headerStates/cashier").toByteArray();
    if(!state.isEmpty())
        ui->tableView->horizontalHeader()->restoreState(state);

    ui->tableView->setItemDelegateForColumn(1,new DoubleSpinBoxDelegate);
    ui->tableView->setItemDelegateForColumn(3,new DoubleSpinBoxDelegate);
    ui->tableView->setItemDelegateForColumn(4,new DoubleSpinBoxDelegate);
    model->requestData();
}

void CashierTab::connectSignals()
{
    connect(QApplication::instance(),&QApplication::aboutToQuit,this,&CashierTab::onAboutToQuit);
    connect(ui->posNumpad,&PosNumpad::digitPressed,this,&CashierTab::onDigitPressed);
    connect(ui->posNumpad,&PosNumpad::backPressed,this,&CashierTab::onBackSpacePressed);
    connect(ui->posNumpad,&PosNumpad::decimalPressed,this,&CashierTab::onDecimalPressed);
    connect(ui->posNumpad,&PosNumpad::clearPressed,this,&CashierTab::onClearPressed);
    connect(ui->tableView,&QTableView::clicked,this,[this](){waitingForDecimal=false;ui->posNumpad->setDecimalChecked(false);});
    connect(model,&CashierModel::modelReset,this,&CashierTab::onModelReset);
}


void CashierTab::onAboutToQuit()
{
    settings.setValue("headerStates/cashier",ui->tableView->horizontalHeader()->saveState());

}

void CashierTab::onDigitPressed(int digit)
{
    bool waiting=waitingForDecimal;
    waitingForDecimal=false;
    ui->posNumpad->setDecimalChecked(false);

   QModelIndex index=ui->tableView->selectionModel()->selectedRows(2).first();
   lastIndex=index;
   double currentQty=index.data().toDouble();

   if(std::fmod(currentQty,1)!=0){
       QString nStr=QString::number(currentQty,'f',5).split('.').value(1);
       nStr.chop(2);
       if(nStr.count('0')==3) //will cause porblems
       return;
   }
   model->setData(index,appendDigit(currentQty,digit,waiting));
}

void CashierTab::onActiveButtonChanged()
{

}

void CashierTab::onClearPressed()
{
    QModelIndex index=ui->tableView->selectionModel()->selectedRows(2).value(0);
    if(index.isValid())
        model->removeRow(index.row());
}

void CashierTab::onDecimalPressed()
{
    QModelIndex index=ui->tableView->selectionModel()->selectedRows(2).first();
    double currentQty=index.data().toDouble();
    if(std::fmod(currentQty,1)==0.0)
    {
        waitingForDecimal=true;
        ui->posNumpad->setDecimalChecked(true);
    }
}

void CashierTab::onBackSpacePressed()
{
    QModelIndex index=ui->tableView->selectionModel()->selectedRows(2).first();
    double currentQty=index.data().toDouble();
    if(currentQty==0){
        onClearPressed();
    }
    else if(std::fmod(currentQty,1)==0){
       model->setData(index,(int)currentQty/10);
    }else{
        QString nStr=QString::number(currentQty,'f',5).split('.').value(1);
        nStr.chop(2);
        int chopCount=0;
        for(int i=nStr.count()-1 ; i>0;i--){
            if(nStr[i]=='0')
                chopCount++;
            else{
                break;
            }
        }
        QString n=QString::number(currentQty,'f',5);
        n.chop(3+chopCount);
        model->setData(index,n.toDouble());
    }

}

void CashierTab::onModelReset()
{
    ui->tableView->selectRow(lastIndex.row());
    ui->totalLE->setText(model->totalCurrencyString());
    ui->taxLE->setText(model->taxAmountCurrencyString());
}


double appendDigit(const double number, const int digit, bool appendAsDecimal, int precesionLimit)
{
    float mod=std::fmod(number,1);
    if(mod==0){
        if(appendAsDecimal==false){
            return (number*10)+digit;
        }
        else {
            return number+(float)digit/10;
        }
    }else{
        int modInt=(float)mod*precesionLimit;
        if(modInt%10!=0){ //may cause a bug
            return number; //enough decimal places
        }
        else{
            int tmp=modInt;
            int power=1;
            while (tmp%10==0) {
                power=power*10;
                tmp=tmp/10;
            }
           modInt=(modInt*10)+(digit*power);

            double newDec=(double)modInt/(precesionLimit*10);
            double dmod=std::fmod(number,1);

            return (number-dmod)+newDec;
        }
    }
}
