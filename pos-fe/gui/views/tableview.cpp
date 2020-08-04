#include "tableview.h"
#include <QMetaObject>
#include <QDebug>
#include <QMetaClassInfo>
#include <QSettings>
#include <QHeaderView>
#include <QApplication>
TableView::TableView(QWidget *parent) : QTableView(parent)
{
    connect(QApplication::instance(),&QApplication::aboutToQuit,this,&TableView::onAboutToQuit);
}

void TableView::onAboutToQuit()
{
    if(!model())
        return;

    QSettings settings;
    QString className=model()->metaObject()->className();
    settings.setValue(QString("TableView-%1").arg(className),horizontalHeader()->saveState());
}

void TableView::setModel(QAbstractItemModel *model)
{
    if(model){
        QString className=model->metaObject()->className();
        QSettings settings;
        QByteArray state=settings.value(QString("TableView-%1").arg(className)).toByteArray();
        if(!state.isNull())
            horizontalHeader()->restoreState(state);

    }
    QTableView::setModel(model);
}
