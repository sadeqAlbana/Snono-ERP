#include "textinputfield.h"
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
TextInputField::TextInputField(QWidget *parent) : QWidget(parent),
    layout(new QHBoxLayout(this)),
    label(new QLabel(this)),
    lineEdit(new QLineEdit(this))
{

    label->setSizePolicy(QSizePolicy::Preferred,QSizePolicy::Preferred);
    lineEdit->setSizePolicy(QSizePolicy::Expanding,QSizePolicy::Fixed);
    layout->addWidget(label);
    layout->addWidget(lineEdit);
    setLayout(layout);
}
