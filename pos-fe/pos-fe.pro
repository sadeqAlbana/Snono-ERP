#-------------------------------------------------
#
# Project created by QtCreator 2019-09-24T11:50:02
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = pos-fe
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    loginwidget.cpp

HEADERS += \
        mainwindow.h \
    loginwidget.h

FORMS += \
        mainwindow.ui \
    loginwidget.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../network-manager/release/ -lnetwork-manager
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../network-manager/debug/ -lnetwork-manager
else:unix: LIBS += -L$$OUT_PWD/../network-manager/ -lnetwork-manager

INCLUDEPATH += $$PWD/../network-manager/src
DEPENDPATH += $$PWD/../network-manager/src

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../network-manager/release/libnetwork-manager.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../network-manager/debug/libnetwork-manager.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../network-manager/release/network-manager.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../network-manager/debug/network-manager.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../network-manager/libnetwork-manager.a

RESOURCES += \
    qrc.qrc
