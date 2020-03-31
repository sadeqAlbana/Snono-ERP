#ifndef DOUBLESPINBOXDELEGATE_H
#define DOUBLESPINBOXDELEGATE_H

#include <QStyledItemDelegate>
#include <QObject>
class DoubleSpinBoxDelegate : public QStyledItemDelegate
{
    Q_OBJECT
public:
    DoubleSpinBoxDelegate(QObject *parent = 0);
    QWidget *createEditor(QWidget *parent, const QStyleOptionViewItem &option,
                          const QModelIndex &index) const override;

    void setEditorData(QWidget *editor, const QModelIndex &index) const override;
    void setModelData(QWidget *editor, QAbstractItemModel *model,
                      const QModelIndex &index) const override;

    void updateEditorGeometry(QWidget *editor,
        const QStyleOptionViewItem &option, const QModelIndex &index) const override;

    QString displayText(const QVariant &value,
                                            const QLocale &locale) const override;



    int decimalPrecision() const;
    void setDecimalPrecision(int decimalPrecision);

private:
    int _decimalPrecision;
};


#endif // DOUBLESPINBOXDELEGATE_H
