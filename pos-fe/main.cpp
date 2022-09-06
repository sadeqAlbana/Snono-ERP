#include <posapplication.h>
#include <QSettings>
#include <mainwindow.h>
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

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("com");
    QCoreApplication::setOrganizationDomain("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");
#ifndef Q_OS_ANDROID
    qputenv("QT_FONT_DPI","96");
#endif
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

#ifndef Q_OS_ANDROID
    QApplication::setAttribute(Qt::AA_Use96Dpi);
#endif

    PosApplication a(argc, argv);



    QLocale english("en");
    QLocale arabicN("ar");
    QLocale arabic("Arabic");

    qDebug()<< english.language();
    qDebug()<< arabicN.language();
    qDebug()<< arabic.language();
    qDebug()<<QLocale::languageToString(QLocale::Arabic);
    qDebug()<<QLocale::languageToCode(QLocale::Arabic);

    return a.exec();
}
