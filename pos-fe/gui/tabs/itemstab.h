#ifndef ITEMSTAB_H
#define ITEMSTAB_H

#include <QWidget>
#include "models/appnetworkedjsonmodel.h"
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
    AppNetworkedJsonModel *model;
};

#endif // ITEMSTAB_H
