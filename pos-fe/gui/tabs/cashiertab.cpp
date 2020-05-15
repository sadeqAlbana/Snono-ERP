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
#include <QTextDocument>
#include <QPrinter>
#include <QFile>
#include "gui/dialogs/receiptdialog.h"
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
    connect(ui->barcodeLE,&QLineEdit::returnPressed,this,[this](){this->model->addProduct(ui->barcodeLE->text());ui->barcodeLE->clear();});
    connect(ui->payButton,&QToolButton::clicked,this,&CashierTab::onPayButtonClicked);
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
    manager.post("/pos/purchase",data)->subcribe(this,&CashierTab::onPurchaseResponse);

}

void CashierTab::onPurchaseResponse(NetworkResponse *res)
{
    qDebug()<<res;
    if(!res->json("status").toBool()){
        QMessageBox::warning(this,"Error",res->json("message").toString());
    }else{
        //QMessageBox::information(this,"Success","please receive the receipt");

        ReceiptDialog::init(this,res->json("receipt").toString());
//        QTextDocument doc;
//        doc.setHtml(res->json("receipt").toString());
//        QFile file("/tmp/recc.html");
//        file.open(QIODevice::WriteOnly);
//        file.write(res->json("receipt").toString().toUtf8());
//        file.close();

//        QPrinter printer(QPrinter::PrinterResolution);
//        printer.setOutputFormat(QPrinter::PdfFormat);
//        printer.setPaperSize(QPrinter::A4);
//        printer.setOutputFileName("/tmp/receipt.pdf");
//        doc.print(&printer);

    }
}

