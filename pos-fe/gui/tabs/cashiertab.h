#ifndef CASHIERTAB_H
#define CASHIERTAB_H

#include <QWidget>
#include <QSettings>
#include <QModelIndex>
#include "posnetworkmanager.h"
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
    void onDigitPressed(int digit);
    void onActiveButtonChanged();
    void onClearPressed();
    void onDecimalPressed();
    void onBackSpacePressed();
    bool waitingForDecimal=false;
    void onModelReset();
    QModelIndex selectedRow();
    void onPayButtonClicked();
    void onPurchaseResponse(NetworkResponse *res);

private:
    Ui::CashierTab *ui;
    CashierModel *model;
    QSettings settings;
    QModelIndex lastIndex;
    PosNetworkManager manager;
};

#endif // CASHIERTAB_H
