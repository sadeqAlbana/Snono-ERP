#ifndef USERSTAB_H
#define USERSTAB_H

#include <QWidget>
class NetworkedJsonModel;
namespace Ui {
class UsersTab;
}

class UsersTab : public QWidget
{
    Q_OBJECT

public:
    explicit UsersTab(QWidget *parent = 0);
    ~UsersTab();



private:
    Ui::UsersTab *ui;
    NetworkedJsonModel *model;
};

#endif // USERSTAB_H
