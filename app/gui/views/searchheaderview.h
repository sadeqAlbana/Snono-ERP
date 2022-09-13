#ifndef SEARCHHEADERVIEW_H
#define SEARCHHEADERVIEW_H
#include <QHeaderView>
#include "headerwidget.h"
class SearchHeaderView : public QHeaderView
{
    Q_OBJECT
public:
    SearchHeaderView(QAbstractItemModel *mdl,QWidget *parent = nullptr);

    QSize sizeHint() const override;

    void updateGeometries() override;

    void setWidgetsPosition();


private:
    void createWidgets();
    QList<HeaderWidget *> widgets;
    QAbstractItemModel *_model;
};

#endif // SEARCHHEADERVIEW_H
