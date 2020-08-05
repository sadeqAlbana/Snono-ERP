#ifndef ACCOUNTINGTAB_H
#define ACCOUNTINGTAB_H

#include <QWidget>

namespace Ui {
class AccountingTab;
}

class AccountingTab : public QWidget
{
    Q_OBJECT

public:
    explicit AccountingTab(QWidget *parent = nullptr);
    ~AccountingTab();

private:
    Ui::AccountingTab *ui;
};

#endif // ACCOUNTINGTAB_H
