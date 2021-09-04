#include "numbereditor.h"
#include <QStringList>

NumberEditor::NumberEditor(QObject *parent) : QObject(parent)
{

}

double NumberEditor::appendDigit(double number, int digit, bool appendToDecimal)
{
    QString numberStr=QString::number(number,'f',5);
    numberStr.chop(2);
    QString digitStr=QString::number(digit);
    QStringList nList=numberStr.split('.');

    if(appendToDecimal){
        QString decimalStr=nList.value(1);
        while (decimalStr.size() && decimalStr.at(decimalStr.size()-1)=='0') {
            decimalStr.chop(1);
        }
        decimalStr+=digitStr;
        nList[1]=decimalStr;
    }else{
        QString integerStr=nList.value(0);
        integerStr+=digitStr;
        nList[0]=integerStr;
    }

    return nList.join('.').toDouble();
}

double NumberEditor::removeDigit(double number)
{
    QString numberStr=QString::number(number,'f',5);
    numberStr.chop(2);
    QStringList nList=numberStr.split('.');

    QString integerStr=nList[0];
    QString decimalStr=nList[1];
    if(decimalStr.count('0')==decimalStr.size()){
        integerStr.chop(1);
        return integerStr.toDouble();
    }else{
        while (decimalStr.size() && decimalStr.at(decimalStr.size()-1)=='0') {
            decimalStr.chop(1);
        }
        decimalStr.chop(1);
        nList[1]=decimalStr;
        return nList.join('.').toDouble();
    }
}

int NumberEditor::decimalCount(double number)
{
    QString numberStr=QString::number(number,'f',5);
    numberStr.chop(2);
    QString decimal=numberStr.split('.').at(1);
    int counter=decimal.size();
    for(int i=decimal.size()-1;i>0;i--){
        if(decimal.at(i)!='0'){
            break;
        }
            counter--;
    }
    return counter;
}
