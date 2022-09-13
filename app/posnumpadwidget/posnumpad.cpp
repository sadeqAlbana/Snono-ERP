#include "posnumpad.h"
#include <QGridLayout>
#include "posnumpadbutton.h"
PosNumpad::PosNumpad(QWidget *parent) : QWidget(parent),_activeButton(QuantityButton)
{

    QGridLayout *layout = new QGridLayout();
    for (int i = 1; i < 10; ++i) {
        int row = ((9 - i) / 3) ;
        int column = ((i - 1) % 3) ;
        layout->addWidget(createButton(QString::number(i),DigitButton), row, column);
    }

    layout->addWidget(createButton(QString::number(0),DigitButton),3,1);
    layout->addWidget(createButton("C",ClearButton), 3, 0);
    decimalButton=createButton(".",DecimalButton);
    layout->addWidget(decimalButton, 3, 2);

    functionButtons[QuantityButton]=createButton("Qty",QuantityButton,QIcon(),true,QColor("#1d99f3"));
    functionButtons[DiscountButton]=createButton("Disc",DiscountButton,QIcon(),false,QColor("#1d99f3"));
    functionButtons[PriceButton]=createButton("Price",PriceButton,QIcon(),false,QColor("#1d99f3"));

    layout->addWidget(functionButtons[QuantityButton],0,3);
    layout->addWidget(functionButtons[DiscountButton],1,3);
    layout->addWidget(functionButtons[PriceButton],2,3);
    layout->addWidget(createButton(QString(),BackspaceButton,QIcon(":/numpad/img/appbar.clear.reflect.horizontal.png")),3,3);
    setLayout(layout);
}



PosNumpadButton *PosNumpad::createButton(const QString &text, const PosNumpadButtonType &type, const QIcon &icon, const bool &active, const QColor color)
{
    PosNumpadButton *button=new PosNumpadButton(text,type, icon,active,color);
    connect(button,&PosNumpadButton::clicked,this,&PosNumpad::onButtonPressed);
    return button;
}



void PosNumpad::setActiveButton(const PosNumpadButtonType &activeButton)
{
    _activeButton=activeButton;

    for (PosNumpadButton *button : functionButtons) {
        if(button->type()==activeButton)
            button->setActive(true);
        else
            button->setActive(false);
    }
    emit activeButtonChanged(activeButton);
}



void PosNumpad::setDecimalChecked(const bool checked)
{

    if(checked){
        decimalButton->setCheckable(true);
        decimalButton->setChecked(true);
    }else{
        decimalButton->setChecked(false);
        decimalButton->setCheckable(false);
    }
}



void PosNumpad::onButtonPressed()
{
    PosNumpadButton *button=qobject_cast<PosNumpadButton *>(sender());
    PosNumpadButtonType type=static_cast<PosNumpadButtonType>(button->type());
    switch (type) {
    case DigitButton     : emit digitPressed(button->text().toInt()); break;
    case DecimalButton   : emit decimalPressed(); break;
    case BackspaceButton : emit backPressed(); break;
    case ClearButton     : emit clearPressed(); break;
    case QuantityButton  :
    case PriceButton     :
    case DiscountButton  : setActiveButton(type); break;
    }
}


