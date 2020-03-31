#ifndef POSNUMPADBUTTON_H
#define POSNUMPADBUTTON_H

#include <QToolButton>
class PosNumpadButton : public QToolButton
{
    Q_OBJECT
    Q_PROPERTY(bool   active MEMBER _active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(QColor color  MEMBER _color  READ color  WRITE setColor  NOTIFY colorChanged)
public:
    explicit PosNumpadButton(const QString &text, const int &type, const QIcon &icon=QIcon(), const bool &active=false, const QColor &color=QColor(), QWidget *parent = nullptr);
    QSize sizeHint() const override;

    bool active() const;
    void setActive(bool active);

    QColor color() const;
    void setColor(const QColor &color);

    int type() const;

signals:
    void activeChanged(bool);
    void colorChanged(QColor color);
private:
    int _type;
    bool _active;
    QColor _color;

};

#endif // POSNUMPADBUTTON_H
