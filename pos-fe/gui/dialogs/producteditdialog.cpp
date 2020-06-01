#include "producteditdialog.h"
#include "ui_producteditdialog.h"
#include <QDebug>
#include <networkresponse.h>
#include <QJsonArray>
#include "checkablelistdialog.h"
ProductEditDialog::ProductEditDialog(QWidget *parent, const QJsonObject &product) :
    QDialog(parent),
    ui(new Ui::ProductEditDialog)
{
    ui->setupUi(this);

    connect(ui->saveButton,&QToolButton::clicked,this,&ProductEditDialog::onSaveButtonClicked);
    ui->typeCB->addItem("Storable Product"  , 1);
    ui->typeCB->addItem("Consumable Product", 2);
    ui->typeCB->addItem("Service Product"   , 3);

    types={{1,"Storable Product"},
           {2,"Consumable Product"},
           {3,"Service Product"   }};

    original=product;
    data=original;
    initFileds();
}

ProductEditDialog::~ProductEditDialog()
{
    delete ui;
}

QJsonObject ProductEditDialog::init(QWidget *parent, const QJsonObject &product)
{
    ProductEditDialog *dlg=new ProductEditDialog(parent,product);

    dlg->exec();
    if(dlg->result()==QDialog::Accepted)
        return dlg->data;

    return QJsonObject();
}

void ProductEditDialog::initFileds()
{
    ui->costSB->setValue((data["cost"].toDouble()));                            //cost
    ui->nameLE->setText(data["name"].toString());                               //name
    ui->barcodeLE->setText(data["barcode"].toString());                         //barcode
    ui->sellPriceSB->setValue((data["list_price"].toDouble()));                 //sell price
    //ui->qtySB->setValue(product["products_stocks"].toObject()["qty"].toDouble());  //quantity
    ui->typeCB->setCurrentText(types[data["type"].toInt()]);
}

void ProductEditDialog::onSaveButtonClicked()
{
    data["id"]=data["id"].toInt();
    data["cost"]=ui->costSB->value();
    data["list_price"]=ui->sellPriceSB->value();
    data["name"]=ui->nameLE->text();
    data["barcode"]=ui->barcodeLE->text();
    data["type"]=ui->typeCB->currentData().toInt();
    data["description"]=QString();
    done(QDialog::Accepted);
}


