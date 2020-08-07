#include "doublespinboxdelegate.h"
#include <QDoubleSpinBox>
#include <QDebug>
DoubleSpinBoxDelegate::DoubleSpinBoxDelegate(QObject *parent) : QStyledItemDelegate(parent)
{
    _decimalPrecision=0;
}


QWidget *DoubleSpinBoxDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem & /*option*/ , const QModelIndex & /*index*/ ) const
{
    QDoubleSpinBox *editor = new QDoubleSpinBox(parent);
    editor->setFrame(false);
    editor->setMinimum(0);
    editor->setMaximum(999999999999999999);
    editor->setDecimals(3);
    editor->setSingleStep(1);
    editor->setGroupSeparatorShown(true);
    editor->setAlignment(Qt::AlignCenter);
    return editor;
}

void DoubleSpinBoxDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const
{
    double value = index.data(Qt::EditRole).toDouble();
    QDoubleSpinBox *spinBox = static_cast<QDoubleSpinBox*>(editor);
    spinBox->setValue(value);
}

void DoubleSpinBoxDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{
    QDoubleSpinBox *spinBox = static_cast<QDoubleSpinBox*>(editor);
    spinBox->interpretText();
    double value = spinBox->value();
    model->setData(index, value, Qt::EditRole);
}

void DoubleSpinBoxDelegate::updateEditorGeometry(QWidget *editor,
    const QStyleOptionViewItem &option, const QModelIndex & /*index*/) const
{
    editor->setGeometry(option.rect);
}

QString DoubleSpinBoxDelegate::displayText(const QVariant &value,const QLocale &locale) const

{
    QString text;
    if(value.userType()==QMetaType::Float || value.userType()==QVariant::Double || value.userType()==QVariant::Int)
    {
        QLocale locale(QLocale::Arabic,QLocale::ArabicScript,QLocale::Iraq);

        text= QLocale(QLocale::English,QLocale::ArabicScript,QLocale::Iraq).toCurrencyString(value.toReal(),locale.currencySymbol(QLocale::CurrencySymbol),0);
        //text= QLocale(QLocale::Arabic,QLocale::Script::ArabicScript,QLocale::Iraq).toCurrencyString(value.toDouble());

        return text;
    }
    else
        return QStyledItemDelegate::displayText(value,locale);
}

int DoubleSpinBoxDelegate::decimalPrecision() const
{
    return _decimalPrecision;
}

void DoubleSpinBoxDelegate::setDecimalPrecision(int decimalPrecision)
{
    _decimalPrecision = decimalPrecision;
}

