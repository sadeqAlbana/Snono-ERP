#include "spinboxdelegate.h"
#include <QSpinBox>
SpinboxDelegate::SpinboxDelegate(QObject *parent) : QStyledItemDelegate(parent)
{

}

QWidget *SpinboxDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem & /*option*/ , const QModelIndex & /*index*/ ) const
{
    QSpinBox *editor = new QSpinBox(parent);
    editor->setFrame(false);
    editor->setMinimum(1);
    editor->setMaximum(1000000000);
    editor->setAlignment(Qt::AlignCenter);
    return editor;
}

void SpinboxDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const
{
    int value = index.data().toInt();
    QSpinBox *spinBox = static_cast<QSpinBox*>(editor);
    spinBox->setValue(value);
}


void SpinboxDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{
    QSpinBox *spinBox = static_cast<QSpinBox*>(editor);
    spinBox->interpretText();
    int value = spinBox->value();
    model->setData(index, value, Qt::EditRole);



    //int price=index.sibling(index.row(),8).data().toInt();
    //double total=value*price;
    //model->setData(index.sibling(index.row(),10),total);

}

void SpinboxDelegate::updateEditorGeometry(QWidget *editor,
    const QStyleOptionViewItem &option, const QModelIndex & /*index*/) const
{
    editor->setGeometry(option.rect);
}
