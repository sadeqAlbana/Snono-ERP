#include <posapplication.h>
#include <QSettings>
#include <mainwindow.h>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "authmanager.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("sadeqTech");
    QCoreApplication::setApplicationName("pos-fe");
    QSettings settings;
//    PosApplication a(argc, argv);
//    a.setStyle("Breeze");


   QGuiApplication a(argc, argv);
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("AuthManager",AuthManager::instance());


    //instances should be added before engine.load
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return a.exec();
}
