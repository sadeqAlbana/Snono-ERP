#ifndef HEADERWIDGET_H
#define HEADERWIDGET_H

#include <QWidget>
#include <QLabel>
class HeaderWidget : public QWidget
{
    Q_OBJECT


public:
    enum WidgetType{
             LineEdit = 1,
             DateEdit = 2,
             ComboBox = 3,
              SpinBox = 4,
        DoubleSpinBox = 5

    };
public:
    explicit HeaderWidget(QString labelText, WidgetType widgetype, QWidget *parent = nullptr);

    void createWidget();

signals:

public slots:

private:
    QLabel *_label;
    QWidget *_widget;
    WidgetType _type;
};

#endif // HEADERWIDGET_H
