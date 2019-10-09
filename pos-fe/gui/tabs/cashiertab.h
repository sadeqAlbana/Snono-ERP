#ifndef CASHIERTAB_H
#define CASHIERTAB_H

#include <QWidget>
#include <QSettings>


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
    void setupView();
    void connectSignals();
    void onAboutToQuit();




private:
    Ui::CashierTab *ui;
    CashierModel *model;
    QSettings settings;
};

#endif // CASHIERTAB_H
