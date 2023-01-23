#include "posapplication.h"
#include <QSettings>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QJsonDocument>
#include <QJsonObject>
#include <QPrinterInfo>
#include <QIcon>
#include <QClipboard>
#include <QDir>
#include <QDirIterator>
#include <QFontDatabase>
#include <QTranslator>
#include <QFileSelector>

#include <QtQml/qqmlextensionplugin.h>
#include <iostream>
Q_IMPORT_QML_PLUGIN(CoreUIPlugin)

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("com");
    QCoreApplication::setOrganizationDomain("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");
    qputenv("QML_DISABLE_DISTANCEFIELD", "1"); //this fixes the artifacts in arabic fonts

    //qputenv("QT_ENABLE_HIGHDPI_SCALING",0);
#ifndef Q_OS_ANDROID
   // qputenv("QT_FONT_DPI","96");
    qputenv("QT_ENABLE_HIGHDPI_SCALING","0");

    //QApplication::setAttribute(Qt::AA_Use96Dpi);
#endif





    PosApplication a(argc, argv);
    QFont font=QApplication::font();
    //font.setHintingPreference(QFont::HintingPreference::PreferNoHinting);

   // font.setFamily("Segoe UI");
    font.setFamilies({
                     "Segoe UI"
                     "Helvetica Neue",
                     "Noto Sans",
                     "Liberation Sans",
                     "Arial",
                     "sans-serif",
                     "Apple Color Emoji",
                     "Segoe UI Emoji",
                     "Segoe UI Symbol",
                     "Noto Color Emoji"});
    font.setWeight(QFont::Weight::Normal);
    font.setPixelSize(16);
    QApplication::setFont(font);



    return a.exec();

    qDebug()<<"Quitted";
}
