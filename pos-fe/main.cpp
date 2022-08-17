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
#include "possettings.h"
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
    qputenv("QML_XHR_ALLOW_FILE_READ","1");
#ifndef Q_OS_ANDROID

    qputenv("QT_FONT_DPI","96");
#endif
    //settings.setValue("http_server_url","http://naaom.net:8000");
    //settings.setValue("http_server_url","http://127.0.0.1:8000");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

#ifndef Q_OS_ANDROID
    QApplication::setAttribute(Qt::AA_Use96Dpi);
#endif

    PosApplication a(argc, argv);
    PosSettings settings;

    //first load font files
    QDirIterator it(":/fonts", QStringList{{"*.ttf"}}, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()){
        QString next= it.next();
        QFontDatabase::addApplicationFont(next);
    }


    const QStringList uiLanguages = QStringList{"ar-IQ"};
    for (const QString &locale : uiLanguages) {
        const QString baseName = "pos-fe_" + QLocale(locale).name();
        QTranslator *translator= new QTranslator(&a);
        translator->load(":/i18n/" + baseName);
    }

    QIcon::setThemeName("CoreUI");
//   QGuiApplication a(argc, argv);
    QQmlApplicationEngine engine;
    engine.setNetworkAccessManagerFactory(new AppQmlNetworkAccessManagerFactory);
    NumberEditor nb;
    ReceiptGenerator gen;

    engine.rootContext()->setContextProperty("KApp",&a);
    engine.rootContext()->setContextProperty("AuthManager",AuthManager::instance());
    engine.rootContext()->setContextProperty("NetworkManager",PosNetworkManager::instance());
    engine.rootContext()->setContextProperty("NumberEditor",&nb);
    engine.rootContext()->setContextProperty("ReceiptGenerator",&gen);
    engine.rootContext()->setContextProperty("Api",Api::instance());
    engine.rootContext()->setContextProperty("Settings",&settings);
    engine.rootContext()->setContextProperty("Clipboard",QApplication::clipboard());

//    TestPalette pal;
//    engine.rootContext()->setContextProperty("Pal",pal);


    qmlRegisterType<AccountsModel>("App.Models", 1, 0, "AccountsModel");

    qmlRegisterType<ProductsModel>("App.Models", 1, 0, "ProductsModel");
    qmlRegisterType<OrdersModel>("App.Models", 1, 0, "OrdersModel");
    qmlRegisterType<OrderItemsModel>("App.Models", 1, 0, "OrderItemsModel");
    qmlRegisterType<CashierModel>("App.Models", 1, 0, "CashierModel");
    qmlRegisterType<CategoriesModel>("App.Models", 1, 0, "CategoriesModel");
    qmlRegisterType<TreeProxyModel>("App.Models", 1, 0, "TreeProxyModel");
    qmlRegisterType<TaxesCheckableModel>("App.Models", 1, 0, "TaxesCheckableModel");
    qmlRegisterType<VendorsModel>("App.Models", 1, 0, "VendorsModel");
    qmlRegisterType<VendorsBillsModel>("App.Models", 1, 0, "VendorsBillsModel");
    qmlRegisterType<CustomersModel>("App.Models", 1, 0, "CustomersModel");
    qmlRegisterType<PosSessionsModel>("App.Models", 1, 0, "PosSessionsModel");
    qmlRegisterType<JournalEntriesItemsModel>("App.Models", 1, 0, "JournalEntriesItemsModel");
    qmlRegisterType<JournalEntriesModel>("App.Models", 1, 0, "JournalEntriesModel");
    qmlRegisterType<TaxesModel>("App.Models", 1, 0, "TaxesModel");
    qmlRegisterType<ReceiptModel>("App.Models", 1, 0, "ReceiptModel");
    qmlRegisterType<VendorCartModel>("App.Models", 1, 0, "VendorCartModel");
    qmlRegisterType<ReturnOrderModel>("App.Models", 1, 0, "ReturnOrderModel");
    qmlRegisterType<CustomVendorCartModel>("App.Models", 1, 0, "CustomVendorCartModel");
    qmlRegisterType<ProductsAttributesAttributesModel>("App.Models", 1, 0, "ProductsAttributesAttributesModel");
    qmlRegisterType<SalesChartModel>("App.Models", 1, 0, "SalesChartModel");
    qmlRegisterType<UsersModel>("App.Models", 1, 0, "UsersModel");
    qmlRegisterType<OrdersReturnsModel>("App.Models", 1, 0, "OrdersReturnsModel");
    qmlRegisterType<AppNetworkedJsonModel>("App.Models", 1, 0, "NetworkModel");
    qmlRegisterType<BarqLocationsModel>("App.Models", 1, 0, "BarqLocationsModel");
    qmlRegisterType<StockReportModel>("App.Models", 1, 0, "StockReportModel");
    qmlRegisterType<ProductSalesReportModel>("App.Models", 1, 0, "ProductSalesReportModel");

    //qmlRegisterType<TestPalette>("test.palettes", 1, 0, "TestPalette");



    //instances should be added before engine.load
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return a.exec();
}
