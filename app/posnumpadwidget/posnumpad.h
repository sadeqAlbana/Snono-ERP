#ifndef POSNUMPAD_H
#define POSNUMPAD_H

#include <QWidget>
class PosNumpadButton;
#include <QIcon>
#include <QMap>
class PosNumpad : public QWidget
{   
    Q_OBJECT
    Q_PROPERTY(PosNumpadButtonType activeButton MEMBER _activeButton READ activeButton WRITE setActiveButton NOTIFY activeButtonChanged)
public:
    explicit PosNumpad(QWidget *parent = nullptr);
    enum PosNumpadButtonType {DigitButton,DecimalButton,ClearButton,BackspaceButton,QuantityButton,PriceButton,DiscountButton};
    Q_ENUM(PosNumpadButtonType)
    void onDigitPressed();
    void setButtonActive(const PosNumpadButtonType buttonType);
    void onQuantityButtonPressed();
    void onPriceButtonPressed();
    void onDiscountButtonPressed();
    PosNumpadButtonType activeButton() const{return _activeButton;}
    void setActiveButton(const PosNumpadButtonType &activeButton);
    void setDecimalChecked(const bool checked);
signals:
    void digitPressed(int digit);
    void backPressed();
    void decimalPressed();
    void clearPressed();
    //void quantityPressed();
    //void pricePressed();
    //void discountPressed();


    void activeButtonChanged(PosNumpadButtonType);

public slots:

private:
    PosNumpadButton* createButton(const QString &text, const PosNumpad::PosNumpadButtonType &type,
                               const QIcon &icon=QIcon(), const bool &active=false, const QColor color=QColor());
    enum { NumDigitButtons = 10 };
    PosNumpadButton *digitButtons[NumDigitButtons];

    PosNumpadButtonType _activeButton;
    void onButtonPressed();
    QMap<PosNumpadButtonType,PosNumpadButton *> functionButtons;
    PosNumpadButton *decimalButton;
};

#endif // POSNUMPAD_H
