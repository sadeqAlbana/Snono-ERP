TEMPLATE = subdirs
CONFIG += have_gui
SUBDIRS += \
    pos-fe
RESOURCES += \
    pos-fe/gui/qrc.qrc

android: include(C:/Users/sadeq/AppData/Local/Android/Sdk/android_openssl/openssl.pri)
