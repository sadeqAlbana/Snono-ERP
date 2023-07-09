#include "keyemitter.h"
#include <QKeyEvent>
#include <QGuiApplication>
#include <QDebug>
KeyEmitter::KeyEmitter(QObject *parent)
    : QObject{parent}
{

}

void KeyEmitter::pressKey(const Qt::Key &key)
{
    qInfo()<<"keyboard: key " << key << " pressed";
    QKeyEvent event (QEvent::KeyPress, key, Qt::NoModifier,QKeySequence(key).toString());
    //    qDebug()<<"Debug: focus object: " << QGuiApplication::focusObject();
    if(QGuiApplication::focusObject()){
        QGuiApplication::sendEvent(QGuiApplication::focusObject(), &event );
    }
}
