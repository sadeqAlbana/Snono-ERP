#include "producteditdialog.h"
#include "ui_producteditdialog.h"
#include <QDebug>
#include <networkresponse.h>
#include <QJsonArray>
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

void ProductEditDialog::init(QWidget *parent, const QJsonObject &product)
{
    ProductEditDialog *dlg=new ProductEditDialog(parent,product);
    dlg->exec();
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
//    if(data==original)
//        return; // do something else

    QJsonObject payload;
    payload["id"]=data["id"].toInt();
    payload["cost"]=ui->costSB->value();
    payload["list_price"]=ui->sellPriceSB->value();
    payload["name"]=ui->nameLE->text();
    payload["barcode"]=ui->barcodeLE->text();
    payload["type"]=ui->typeCB->currentData().toInt();
    payload["description"]=QString();
    payload["taxes"]=QJsonArray();

   manager.post("/products/update",payload)->subcribe(this,&ProductEditDialog::onSaveResponse);
}

void ProductEditDialog::onSaveResponse(NetworkResponse *res)
{
    QJsonObject response=res->json().toObject();
    qDebug()<<res->json();

}
