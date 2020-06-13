#ifndef TEXTINPUTFIELD_H
#define TEXTINPUTFIELD_H

#include <QWidget>
class QHBoxLayout;
class QLabel;
class QLineEdit;
class TextInputField : public QWidget
{
    Q_OBJECT
public:
    explicit TextInputField(QWidget *parent = nullptr);

signals:

public slots:

private:
    QHBoxLayout *layout;
    QLabel *label;
    QLineEdit *lineEdit;
};

#endif // TEXTINPUTFIELD_H
