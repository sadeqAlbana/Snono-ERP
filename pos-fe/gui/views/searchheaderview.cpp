#include "searchheaderview.h"
#include <QLineEdit>
#include <QDebug>
#include <QScrollBar>
#include <QTableView>
SearchHeaderView::SearchHeaderView(QAbstractItemModel *mdl, QWidget *parent) : QHeaderView(Qt::Horizontal, parent)
{
    _model=mdl;
    setSectionsClickable(true);
    createWidgets();
    connect(this,&SearchHeaderView::sectionResized,this,&SearchHeaderView::setWidgetsPosition);
    connect(horizontalScrollBar(),&QScrollBar::valueChanged,this,&SearchHeaderView::setWidgetsPosition);
    connect(verticalScrollBar(),&QScrollBar::valueChanged,this,&SearchHeaderView::setWidgetsPosition);

}

QSize SearchHeaderView::sizeHint() const
{
    QSize size=QHeaderView::sizeHint();

    if(widgets.size())
        size.setHeight(size.height()*2);
    return size;
}

void SearchHeaderView::updateGeometries()
{
    QHeaderView::updateGeometries();
    setWidgetsPosition();
}

void SearchHeaderView::setWidgetsPosition()
{
    for(int i=0; i<widgets.size(); i++)
    {
        QWidget *widget=widgets.at(i);
        widget->setGeometry(sectionViewportPosition(i),
                            0,
                            sectionSize(i)-5,
                            height());
    }
}

void SearchHeaderView::createWidgets()
{
    for(int i=0; i<6; i++)
    {
        HeaderWidget *le=new HeaderWidget(_model->headerData(i,Qt::Horizontal).toString(),HeaderWidget::LineEdit,this);
        widgets << le;
    }

    setWidgetsPosition();
}
