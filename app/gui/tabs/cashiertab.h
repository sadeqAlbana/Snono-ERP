#ifndef CASHIERTAB_H
#define CASHIERTAB_H

#include <QWidget>
#include <QSettings>
#include <QModelIndex>
class CashierModel;
class CustomersModel;
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
    void onPurchaseResponse(QJsonObject res);
    void onUpdateCustomerReplyReceived(QJsonObject res);
    void onCustomerCbIndexChanged(int index);
    void onModelDataReceived();

private:
    Ui::CashierTab *ui;
    CashierModel *model;
    CustomersModel *customersModel;
    QSettings settings;
    QModelIndex lastIndex;
};

#endif // CASHIERTAB_H
