#-------------------------------------------------
#
# Project created by QtCreator 2019-09-24T11:50:02
#
#-------------------------------------------------

QT += core widgets network gui quick quickcontrols2 multimedia printsupport serialport charts svg core5compat pdf

#greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = pos-fe
TEMPLATE = app
win32: RC_ICONS = icons/SS_Brandmark_Blue.ico
# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


include(posnumpadwidget/posnumpadwidget.pri)
include(../json-model/json-model.pri)
include(libs/QrCodeGenerator/QrCodeGenerator.pri)
include(coreui-qml/CoreUI-QML.pri)
include(../network-manager/network-manager.pri)
android{
QT -= pdf
DEFINES += QT_NO_PDF
ANDROID_HOME = $$(ANDROID_HOME)
include($$ANDROID_HOME/android_openssl/openssl.pri)

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

}
#    contains(QMAKE_HOST.os, Windows){
#        include($$ANDROID_HOME/AppData/Local/Android/Sdk/android_openssl/openssl.pri)
#    }
}

wasm{
QT -= pdf serialport
DEFINES += QT_NO_PDF
}




SOURCES += \
    api.cpp \
    appqmlnetworkaccessmanagerfactory.cpp \
    appsettings.cpp \
    code128.cpp \
    code128item.cpp \
    main.cpp \
    models/appnetworkedjsonmodel.cpp \
    models/barqlocationsmodel.cpp \
    models/categoriesmodel.cpp \
    models/charts/saleschartmodel.cpp \
    models/customersmodel.cpp \
    models/customvendorcartmodel.cpp \
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
    models/productsalesreportmodel.cpp \
    models/productsattributesattributesmodel.cpp \
    models/receiptmodel.cpp \
    models/returnordermodel.cpp \
    models/stockreportmodel.cpp \
    models/taxescheckablemodel.cpp \
    models/taxesmodel.cpp \
    models/usersmodel.cpp \
    models/vendorcartmodel.cpp \
    models/vendorsbillsmodel.cpp \
    models/vendorsmodel.cpp \
    posnetworkmanager.cpp \
    posapplication.cpp \
    models/productsmodel.cpp \
    receiptgenerator.cpp \
    testpalette.cpp \
    utils.cpp \
    models/accountsmodel.cpp

HEADERS += \
    api.h \
    appqmlnetworkaccessmanagerfactory.h \
    appsettings.h \
    code128.h \
    code128item.h \
    models/Models \
    models/appnetworkedjsonmodel.h \
    models/barqlocationsmodel.h \
    models/categoriesmodel.h \
    models/charts/saleschartmodel.h \
    models/customersmodel.h \
    models/customvendorcartmodel.h \
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
    models/productsalesreportmodel.h \
    models/productsattributesattributesmodel.h \
    models/receiptmodel.h \
    models/returnordermodel.h \
    models/stockreportmodel.h \
    models/taxescheckablemodel.h \
    models/taxesmodel.h \
    models/usersmodel.h \
    models/vendorcartmodel.h \
    models/vendorsbillsmodel.h \
    models/vendorsmodel.h \
    posnetworkmanager.h \
    posapplication.h \
    models/productsmodel.h \
    receiptgenerator.h \
    testpalette.h \
    utils.h \
    models/accountsmodel.h


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target



RESOURCES += \
    images.qrc \
    qml/qml.qrc \
    fonts/fonts.qrc \
    misc/receipt.qrc

TRANSLATIONS += \
    language/pos-fe_ar_IQ.ts

CONFIG += lrelease
CONFIG += embed_translations

#target.path = ~/pos-fe
#INSTALLS += target






