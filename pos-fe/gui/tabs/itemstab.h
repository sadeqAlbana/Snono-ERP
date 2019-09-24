#ifndef ITEMSTAB_H
#define ITEMSTAB_H

#include <QWidget>
//#include "network/messagehandler.h"
#include "models/jsonModel/networkedjsonmodel.h"
namespace Ui {
class ItemsTab;
}

class ItemsTab : public QWidget
{
    Q_OBJECT

public:
    explicit ItemsTab(QWidget *parent = 0);
    ~ItemsTab();

private:
    Ui::ItemsTab *ui;
    NetworkedJsonModel *model;
};

#endif // ITEMSTAB_H
