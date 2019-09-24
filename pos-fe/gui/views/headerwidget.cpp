#include "headerwidget.h"

#include <QLineEdit>
#include <QLabel>
#include <QDateEdit>
#include <QComboBox>
#include <QSpinBox>
#include <QDoubleSpinBox>
#include <QVBoxLayout>

HeaderWidget::HeaderWidget(QString labelText, WidgetType widgetype, QWidget *parent) : QWidget(parent)
{
    _type=widgetype;
    setStyleSheet(R"(
                  QLineEdit {
                      border: 1px solid gray;
                      border-radius: 10px;
                      padding: 0 8px;
                  }

                  )");
    setAutoFillBackground(true);
    _label=new QLabel(labelText, this);
    _label->setAlignment(Qt::AlignCenter);
    createWidget();
    QVBoxLayout *layout=new QVBoxLayout();
    layout->addWidget(_label);
    layout->addWidget(_widget);
    setLayout(layout);
}

void HeaderWidget::createWidget()
{
    switch (_type)
    {
        case LineEdit:      _widget=new QLineEdit();      break;
        case DateEdit:      _widget=new QDateEdit();       break;
        case ComboBox:      _widget=new QComboBox();      break;
        case SpinBox:       _widget=new QSpinBox();       break;
        case DoubleSpinBox: _widget=new QDoubleSpinBox(); break;
    }
}
