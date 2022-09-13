#ifndef TABLEVIEW_H
#define TABLEVIEW_H

#include <QTableView>

class TableView : public QTableView
{
    Q_OBJECT
public:
    explicit TableView(QWidget *parent = nullptr);

    void onAboutToQuit();

    virtual void setModel(QAbstractItemModel *model) override;
};

#endif // TABLEVIEW_H
