#include <posapplication.h>
#include <QSettings>
#include <mainwindow.h>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "authmanager.h"
#include "posnumpadwidget/utils/numbereditor.h"

#include "receiptgenerator.h"
#include <QTimer>
#include <QJsonDocument>
#include <QJsonObject>
#include "models/Models"
#include "api.h"
#include <QPrinterInfo>
#include <QIcon>
#include "appsettings.h"
#include "models/appnetworkedjsonmodel.h"
#include "models/stockreportmodel.h"
#include "models/productsalesreportmodel.h"

#include "appqmlnetworkaccessmanagerfactory.h"
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



    return a.exec();
}
