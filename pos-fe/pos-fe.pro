#-------------------------------------------------
#
# Project created by QtCreator 2019-09-24T11:50:02
#
#-------------------------------------------------

QT       += core widgets network gui quick quickcontrols2 multimedia printsupport
#greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

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

include(posnumpadwidget/posnumpadwidget.pri)
include(../json-model/json-model.pri)


SOURCES += \
        main.cpp \
    models/appnetworkedjsonmodel.cpp \
    models/categoriesmodel.cpp \
    models/customersmodel.cpp \
    models/journalentriesitemsmodel.cpp \
    models/journalentriesmodel.cpp \
    models/jsonModel/checkablelistmodel.cpp \
    models/cashiermodel.cpp \
    authmanager.cpp \
    models/jsonModel/treeproxymodel.cpp \
    models/orderitemsmodel.cpp \
    models/orderreturnitemsmodel.cpp \
    models/ordersmodel.cpp \
    models/ordersreturnsmodel.cpp \
    models/possessionsmodel.cpp \
    models/receiptmodel.cpp \
    models/returnordermodel.cpp \
    models/taxescheckablemodel.cpp \
    models/taxesmodel.cpp \
    models/usersmodel.cpp \
    models/vendorcartmodel.cpp \
    models/vendorsbillsmodel.cpp \
    models/vendorsmodel.cpp \
    posnetworkmanager.cpp \
    posapplication.cpp \
    possettings.cpp \
    models/productsmodel.cpp \
    receiptgenerator.cpp \
    utils.cpp \
    models/accountsmodel.cpp

HEADERS += \
    models/appnetworkedjsonmodel.h \
    models/categoriesmodel.h \
    models/customersmodel.h \
    models/journalentriesitemsmodel.h \
    models/journalentriesmodel.h \
    models/jsonModel/checkablelistmodel.h \
    models/cashiermodel.h \
    authmanager.h \
    models/jsonModel/treeproxymodel.h \
    models/orderitemsmodel.h \
    models/orderreturnitemsmodel.h \
    models/ordersmodel.h \
    models/ordersreturnsmodel.h \
    models/possessionsmodel.h \
    models/receiptmodel.h \
    models/returnordermodel.h \
    models/taxescheckablemodel.h \
    models/taxesmodel.h \
    models/usersmodel.h \
    models/vendorcartmodel.h \
    models/vendorsbillsmodel.h \
    models/vendorsmodel.h \
    posnetworkmanager.h \
    posapplication.h \
    possettings.h \
    models/productsmodel.h \
    receiptgenerator.h \
    utils.h \
    models/accountsmodel.h


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
include(coreui-qml/CoreUI-QML.pri)
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
    images.qrc \
    qml/qml.qrc


#target.path = ~/pos-fe
#INSTALLS += target
