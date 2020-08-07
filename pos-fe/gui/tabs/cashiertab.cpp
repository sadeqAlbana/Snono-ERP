#include "cashiertab.h"
#include "ui_cashiertab.h"
#include <models/cashiermodel.h>
#include "gui/dialogs/makepaymentdialog.h"
#include <QMessageBox>
#include "gui/views/searchheaderview.h"
#include "gui/delegates/doublespinboxdelegate.h"
#include <QLocale>
#include <QtMath>
#include "utils/numbereditor.h"
#include <QTextDocument>
#include <QPrinter>
#include <QFile>
#include "gui/dialogs/receiptdialog.h"
#include "models/customersmodel.h"
#include "messageservice.h"
CashierTab::CashierTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CashierTab),customersModel(new CustomersModel(this))
{
    ui->setupUi(this);

    setupView();
    connectSignals();

    ui->customerCB->setModel(customersModel);
    ui->customerCB->setModelColumn(1);
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
    connect(ui->barcodeLE,&QLineEdit::returnPressed,this,[this](){this->model->addProduct(ui->barcodeLE->text());ui->barcodeLE->clear();});
    connect(ui->payButton,&QToolButton::clicked,this,&CashierTab::onPayButtonClicked);
    connect(model,&CashierModel::purchaseResponseReceived,this,&CashierTab::onPurchaseResponse);
    connect(model,&CashierModel::updateCustomerReplyReceived,this,&CashierTab::onUpdateCustomerReplyReceived);
    connect(model,&CashierModel::dataRecevied,this,&CashierTab::onModelDataReceived);
    connect(ui->customerCB,static_cast<void(QComboBox::*)(int)>(&QComboBox::currentIndexChanged),
            this,&CashierTab::onCustomerCbIndexChanged);
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

    QModelIndex index=selectedRow();

    switch (ui->posNumpad->activeButton()) {
    case  PosNumpad::QuantityButton: index=index.sibling(index.row(),2); break;
    case  PosNumpad::PriceButton: index=index.sibling(index.row(),1);    break;
    //case  PosNumpad::DiscountButton: index=index.sibling(index.row(),2);
    }

   double value=index.data().toDouble();

   model->setData(index,NumberEditor::appendDigit(value,digit,waiting));
}

void CashierTab::onActiveButtonChanged()
{

}

void CashierTab::onClearPressed()
{
    QModelIndex index=selectedRow();

    if(index.isValid())
        model->removeProduct(index.row());
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
    QModelIndex index=selectedRow();

    PosNumpad::PosNumpadButtonType activeButton=ui->posNumpad->activeButton();
    switch (activeButton) {
    case  PosNumpad::QuantityButton: index=index.sibling(index.row(),2); break;
    case  PosNumpad::PriceButton: index=index.sibling(index.row(),1);    break;
    //case  PosNumpad::DiscountButton: index=index.sibling(index.row(),2);
    default: return;
    }

    double value=index.data().toDouble();

    if(value==0 && activeButton==PosNumpad::QuantityButton){
        onClearPressed();
    }
    else{
        model->setData(index,NumberEditor::removeDigit(value));
    }
}

void CashierTab::onModelReset()
{
    ui->tableView->selectRow(lastIndex.row());
    ui->totalLE->setText(model->totalCurrencyString());
    ui->taxLE->setText(model->taxAmountCurrencyString());
}

QModelIndex CashierTab::selectedRow()
{
    QModelIndex index=ui->tableView->selectionModel()->selectedRows().value(0);
    if(index.isValid())
        lastIndex=index;

    return index;
}


void CashierTab::onPayButtonClicked()
{
    double paid=0;
    double change=0;
    bool ok=MakePaymentDialog::init(model->total(),paid,change,this);
    if(!ok)
        return;

    QJsonObject data{{"paid",paid},
                     {"returned",change},
                     {"cart",model->cartData()}};
    model->processCart(paid,change);

}

void CashierTab::onPurchaseResponse(QJsonObject res)
{
    if(!res["status"].toBool()){
        QMessageBox::warning(this,"Error",res["message"].toString());
    }else{
        ReceiptDialog::init(this,res["receipt"].toString());
    }
}

void CashierTab::onUpdateCustomerReplyReceived(QJsonObject res)
{
    if(!res["status"].toBool()){
        MessageService::warning("Error",res["message"].toString());
        model->refresh();
    }
}

void CashierTab::onCustomerCbIndexChanged(int index)
{
    qDebug()<<"index changed";
    int customerId=customersModel->data(index)["id"].toInt();
    if(customerId!=model->customerId())
        model->updatedCustomer(customerId);
}

void CashierTab::onModelDataReceived()
{
    int customerId=model->customerId();
    for(int i=0; i<customersModel->rowCount();i++){
        QJsonObject customer=customersModel->data(i);
        if(customer["id"].toInt()==customerId)
            ui->customerCB->setCurrentIndex(i);
    }
}

