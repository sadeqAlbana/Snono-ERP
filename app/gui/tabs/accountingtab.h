#ifndef ACCOUNTINGTAB_H
#define ACCOUNTINGTAB_H

#include <QWidget>
#include <QJsonObject>
class AccountsModel;
namespace Ui {
class AccountingTab;
}

class AccountingTab : public QWidget
{
    Q_OBJECT

public:
    explicit AccountingTab(QWidget *parent = nullptr);
    ~AccountingTab();

private slots:
    void on_depositCashButon_clicked();
    void onDepositCashResponse(QJsonObject res);

private:
    Ui::AccountingTab *ui;
    AccountsModel *model;
};

#endif // ACCOUNTINGTAB_H
