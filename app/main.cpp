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
#include <QSysInfo>
#include "appsettings.h"
Q_IMPORT_QML_PLUGIN(CoreUIPlugin)

int main(int argc, char *argv[])
{


    if(argc>1){
        for(int i=0; i<argc; i++){
            QString arg= argv[i];
            if(arg=="--version"){
                qInfo()<<"Application version: " <<AppSettings::version();
                return 0;
            }
        }
    }

    QCoreApplication::setOrganizationDomain("com");
    QCoreApplication::setOrganizationName("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");


    qputenv("QML_DISABLE_DISTANCEFIELD", "1"); //this fixes the artifacts in arabic fonts

#ifdef Q_OS_WINDOWS
    //qputenv("QT_SCALE_FACTOR_ROUNDING_POLICY","PassThrough");
    //qputenv("QT_ENABLE_HIGHDPI_SCALING","1");
    //qputenv("QT_SCALE_FACTOR","1.25");
    qputenv("QT_FONT_DPI","96");
#endif
#ifndef Q_OS_ANDROID
//    qputenv("QT_ENABLE_HIGHDPI_SCALING","0");

    //QApplication::setAttribute(Qt::AA_Use96Dpi);
#endif





    PosApplication a(argc, argv);

    // auto printers = QPrinterInfo::availablePrinters();
    // for(auto printer : printers){
    //     qDebug()<<printer.printerName() << ": " << printer.defaultPageSize() << printer.supportedDuplexModes();
    // }

#ifndef Q_OS_ANDROID

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
#endif


    return a.exec();

}
