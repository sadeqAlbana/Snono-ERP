#ifndef PRODUCTEDITDIALOG_H
#define PRODUCTEDITDIALOG_H

#include <QDialog>
#include <QJsonObject>
namespace Ui {
class ProductEditDialog;
}

class ProductEditDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ProductEditDialog(QWidget *parent, const QJsonObject &product);
    ~ProductEditDialog();
    static void init(QWidget *parent, const QJsonObject &product);

private:
    Ui::ProductEditDialog *ui;
    QJsonObject original;
    QJsonObject data;
};

#endif // PRODUCTEDITDIALOG_H
