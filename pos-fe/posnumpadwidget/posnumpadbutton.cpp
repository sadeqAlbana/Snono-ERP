#include "posnumpadbutton.h"
#include <QIcon>
#include <QDebug>
#include <QLayout>
#include <QStyleOptionToolButton>
#include <QFontMetrics>
PosNumpadButton::PosNumpadButton(const QString &text, const int &type, const QIcon &icon, const bool &active, const QColor &color, QWidget *parent) :
    QToolButton(parent),
    _type(type),
    _color(color)
{
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);
    setText(text);
    setToolButtonStyle(Qt::ToolButtonTextOnly);
    setIconSize(QSize(48,48));
    if(!icon.isNull()){
       setIcon(icon);
       setToolButtonStyle(Qt::ToolButtonIconOnly);
    }
    setActive(active);

}


QSize PosNumpadButton::sizeHint() const
{
    if(!(toolButtonStyle()==Qt::ToolButtonIconOnly))
    {
        QSize size = QToolButton::sizeHint();
        size.rheight() += 20;
        size.rwidth() = qMax(size.width(), size.height());
        return size;
    }

    ensurePolished();
    QStyleOptionToolButton opt;
    initStyleOption(&opt);
    return opt.iconSize;
}

bool PosNumpadButton::active() const
{
    return _active;
}

void PosNumpadButton::setActive(bool active)
{
    _active = active;
    if(active)
        setStyleSheet(QString("background-color:%1; color:white").arg(color().name(QColor::HexRgb)));
    else
        setStyleSheet(QString());
    emit activeChanged(active);
}

QColor PosNumpadButton::color() const
{
    return _color;
}

void PosNumpadButton::setColor(const QColor &color)
{
    _color = color;
    if(active()){
        setStyleSheet(QString("background-color:%1; color:white").arg(color.name(QColor::HexRgb)));
    }
    emit colorChanged(color);
}

int PosNumpadButton::type() const
{
    return _type;
}
