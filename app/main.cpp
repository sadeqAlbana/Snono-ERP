#include "posapplication.h"
#include <QSettings>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QTimer>
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
Q_IMPORT_QML_PLUGIN(CoreUIPlugin)
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("com");
    QCoreApplication::setOrganizationDomain("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");
//#ifndef Q_OS_ANDROID
//    qputenv("QT_FONT_DPI","96");
//#endif


//#ifndef Q_OS_ANDROID
//    QApplication::setAttribute(Qt::AA_Use96Dpi);
//#endif



    PosApplication a(argc, argv);
    QFont font=QApplication::font();
    //font.setFamily("Segoe UI");
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
//    QDirIterator it(":/", QStringList{{"main.qml"}}, QDir::Files, QDirIterator::Subdirectories);
//    while (it.hasNext()){
//        QString next= it.next();
//        qDebug().noquote()<<QString("PosFe/%1").arg(it.filePath());
//    }


    return a.exec();
}
