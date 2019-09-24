#ifndef CASHIERTAB_H
#define CASHIERTAB_H

#include <QWidget>



class CashierModel;
namespace Ui {
class CashierTab;
}

class CashierTab : public QWidget
{
    Q_OBJECT

public:
    explicit CashierTab(QWidget *parent = nullptr);
    ~CashierTab();



private:
    Ui::CashierTab *ui;
    CashierModel *model;
};

#endif // CASHIERTAB_H
