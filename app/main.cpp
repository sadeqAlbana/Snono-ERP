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
#include "appsettings.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("com");
    QCoreApplication::setOrganizationDomain("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");
//#ifndef Q_OS_ANDROID
//    qputenv("QT_FONT_DPI","96");
//#endif
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

//#ifndef Q_OS_ANDROID
//    QApplication::setAttribute(Qt::AA_Use96Dpi);
//#endif



    PosApplication a(argc, argv);

//    QDirIterator it(":/", QStringList{{"main.qml"}}, QDir::Files, QDirIterator::Subdirectories);
//    while (it.hasNext()){
//        QString next= it.next();
//        qDebug().noquote()<<QString("PosFe/%1").arg(it.filePath());
//    }


    return a.exec();
}
