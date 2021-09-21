#-------------------------------------------------
#
# Project created by QtCreator 2019-09-24T11:50:02
#
#-------------------------------------------------

QT       += core gui network printsupport quickwidgets quick quickcontrols2 multimedia
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

include(posnumpadwidget/posnumpadwidget.pri)
include(../json-model/json-model.pri)


SOURCES += \
    #gui/dialogs/checkablelistdialog.cpp \
    #gui/dialogs/orderdialog.cpp \
    #gui/dialogs/receiptdialog.cpp \
    #gui/tabs/accountingtab.cpp \
    #gui/tabs/orderstab.cpp \
    #gui/textinputfield.cpp \
    #gui/views/tableview.cpp \
        main.cpp \
    #   mainwindow.cpp \
    #gui/delegates/doublespinboxdelegate.cpp \
    #gui/delegates/spinboxdelegate.cpp \
    #gui/dialogs/adduserdialog.cpp \
    #gui/dialogs/logindialog.cpp \
    #gui/dialogs/makepaymentdialog.cpp \
    #gui/tabs/cashiertab.cpp \
    #gui/tabs/debugtab.cpp \
    #gui/tabs/itemstab.cpp \
    #gui/tabs/userstab.cpp \
    #gui/views/headerwidget.cpp \
    #gui/views/searchheaderview.cpp \
    messageservice.cpp \
    models/appnetworkedjsonmodel.cpp \
    models/categoriesmodel.cpp \
    models/customersmodel.cpp \
    models/jsonModel/checkablelistmodel.cpp \
    models/journalentryitemsmodel.cpp \
    models/cashiermodel.cpp \
    authmanager.cpp \
    models/jsonModel/treeproxymodel.cpp \
    models/orderitemsmodel.cpp \
    models/ordersmodel.cpp \
    models/taxescheckablemodel.cpp \
    models/usersmodel.cpp \
    models/vendorsbillsmodel.cpp \
    models/vendorsmodel.cpp \
    posnetworkmanager.cpp \
    #gui/dialogs/networkerrordialog.cpp \
    posapplication.cpp \
    #gui/dialogs/loginsettingsdialog.cpp \
    possettings.cpp \
    #gui/tabs/productstab.cpp \
    models/productsmodel.cpp \
    #gui/dialogs/producteditdialog.cpp \
    utils.cpp \
    models/accountsmodel.cpp

HEADERS += \
    #gui/dialogs/checkablelistdialog.h \
    #gui/dialogs/orderdialog.h \
    #gui/dialogs/receiptdialog.h \
    #gui/tabs/accountingtab.h \
    #gui/tabs/orderstab.h \
    #gui/textinputfield.h \
    #gui/views/tableview.h \
    #   mainwindow.h \
    #gui/delegates/doublespinboxdelegate.h \
    #gui/delegates/spinboxdelegate.h \
    #gui/dialogs/adduserdialog.h \
    #gui/dialogs/logindialog.h \
    #gui/dialogs/makepaymentdialog.h \
    #gui/tabs/cashiertab.h \
    #gui/tabs/debugtab.h \
    #gui/tabs/itemstab.h \
    #gui/tabs/userstab.h \
    #gui/views/headerwidget.h \
    #gui/views/searchheaderview.h \
    messageservice.h \
    models/appnetworkedjsonmodel.h \
    models/categoriesmodel.h \
    models/customersmodel.h \
    models/jsonModel/checkablelistmodel.h \
    models/journalentryitemsmodel.h \
    models/cashiermodel.h \
    authmanager.h \
    models/jsonModel/treeproxymodel.h \
    models/orderitemsmodel.h \
    models/ordersmodel.h \
    models/taxescheckablemodel.h \
    models/usersmodel.h \
    models/vendorsbillsmodel.h \
    models/vendorsmodel.h \
    posnetworkmanager.h \
    #gui/dialogs/networkerrordialog.h \
    posapplication.h \
    #gui/dialogs/loginsettingsdialog.h \
    possettings.h \
    #gui/tabs/productstab.h \
    models/productsmodel.h \
    #gui/dialogs/producteditdialog.h \
    utils.h \
    models/accountsmodel.h

FORMS += \
    #gui/dialogs/checkablelistdialog.ui \
    #gui/dialogs/orderdialog.ui \
    #gui/dialogs/receiptdialog.ui \
    #gui/tabs/accountingtab.ui \
    #gui/tabs/orderstab.ui \
    #    mainwindow.ui \
    #gui/dialogs/adduserdialog.ui \
    #gui/dialogs/logindialog.ui \
    #gui/dialogs/makepaymentdialog.ui \
    #gui/tabs/cashiertab.ui \
    #gui/tabs/debugtab.ui \
    #gui/tabs/itemstab.ui \
    #gui/tabs/userstab.ui \
    #gui/dialogs/loginsettingsdialog.ui \
    #gui/tabs/productstab.ui \
    #gui/dialogs/producteditdialog.ui

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
    qrc.qrc \
    qml/qml.qrc

DISTFILES +=
