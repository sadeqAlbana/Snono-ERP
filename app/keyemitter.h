#ifndef KEYEMITTER_H
#define KEYEMITTER_H

#include <QObject>
#include <QQmlEngine>
//https://doc.qt.io/archives/qt-4.8/qt-tools-inputpanel-example.html
//https://stackoverflow.com/questions/25053147/simulating-key-press-in-c-for-use-in-qml-for-virtual-keyboard
class KeyEmitter : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit KeyEmitter(QObject *parent = nullptr);
    Q_INVOKABLE void pressKey(const Qt::Key &key);
signals:



};

#endif // KEYEMITTER_H
