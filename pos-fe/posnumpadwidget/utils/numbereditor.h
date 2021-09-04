#ifndef NUMBEREDITOR_H
#define NUMBEREDITOR_H
#include <QObject>
class NumberEditor : public QObject {
    Q_OBJECT
public:

    NumberEditor(QObject *parent=nullptr);

   Q_INVOKABLE static double appendDigit(double number,int digit, bool appendToDecimal);
   Q_INVOKABLE static double removeDigit(double number);
   Q_INVOKABLE static int decimalCount(double number);
};


#endif // NUMBEREDITOR_H
