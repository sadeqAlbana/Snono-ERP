#ifndef PRODUCTEDITDIALOG_H
#define PRODUCTEDITDIALOG_H

#include <QDialog>
#include <QJsonObject>
//#include <posnetworkmanager.h>
#include <QMap>
namespace Ui {
class ProductEditDialog;
}
class ProductEditDialog : public QDialog
{
    Q_OBJECT
public:

    enum ProductType{
        StorableProduct   = 1, //physical stockable product
        ConsumableProduct = 2, //physical non-stockable product
        ServiceProduct    = 3  //non phyiscal Product
    };
    Q_ENUM(ProductType)

    explicit ProductEditDialog(QWidget *parent, const QJsonObject &product);
    ~ProductEditDialog();
    static QJsonObject init(QWidget *parent, const QJsonObject &product);
    void initFileds();
    void onSaveButtonClicked();
    void editTaxes();


private:
    Ui::ProductEditDialog *ui;
    QJsonObject original;
    QJsonObject data;
    QMap<int,QString> types;
};

#endif // PRODUCTEDITDIALOG_H
