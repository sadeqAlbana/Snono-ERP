#include "posapplication.h"
#include <QDebug>
#include <QDirIterator>
#include <QFontDatabase>
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
PosApplication::PosApplication(int &argc, char **argv) : QApplication(argc, argv),
    m_settings(new AppSettings(this)),
    m_engine(new QQmlApplicationEngine(this))
{
    loadFonts();
    loadTranslators();
    initSettings();
    QIcon::setThemeName("CoreUI");
    m_engine->setNetworkAccessManagerFactory(new AppQmlNetworkAccessManagerFactory);
    NumberEditor *nb=new NumberEditor(this);
    ReceiptGenerator *gen=new ReceiptGenerator(this);

    m_engine->rootContext()->setContextProperty("App",this);
    m_engine->rootContext()->setContextProperty("AuthManager",AuthManager::instance());
    m_engine->rootContext()->setContextProperty("NetworkManager",PosNetworkManager::instance());
    m_engine->rootContext()->setContextProperty("NumberEditor",nb);
    m_engine->rootContext()->setContextProperty("ReceiptGenerator",gen);
    m_engine->rootContext()->setContextProperty("Api",Api::instance());
    m_engine->rootContext()->setContextProperty("Settings",m_settings);
    m_engine->rootContext()->setContextProperty("Clipboard",QApplication::clipboard());


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




    //instances should be added before engine.load
    m_engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (m_engine->rootObjects().isEmpty())
        this->exit(-1);
}

PosApplication::~PosApplication()
{

}

QStringList PosApplication::languages() const
{
    QStringList list;

    list << "English";
    for(const QTranslator *translator : m_translators){
        list << QLocale(translator->language()).nativeLanguageName();
    }
    return list;
}

void PosApplication::initSettings()
{
    // qDebug()<<"init settings";
}

void PosApplication::loadFonts()
{
    //first load font files
    QDirIterator it(":/fonts", QStringList{{"*.ttf"}}, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()){
        QString next= it.next();
        QFontDatabase::addApplicationFont(next);
    }
}

void PosApplication::loadTranslators()
{
    QDirIterator it(":/i18n", QStringList{{"*.qm"}}, QDir::Files);
    while (it.hasNext()){
        QString next= it.next();
        QTranslator *translator= new QTranslator(this);
        if(translator->load(next)){
            m_translators << translator;
            qDebug()<<"translator language: " << translator->language();
            qDebug()<<"language direction: " << QLocale(translator->language()).textDirection();
        }
    }
}
