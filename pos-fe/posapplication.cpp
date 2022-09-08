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
    m_engine(new QQmlApplicationEngine(this))
{
    loadFonts();
    loadTranslators();
    initSettings();
    updateAppLanguage();

    QIcon::setThemeName("CoreUI");
    connect(this,&PosApplication::languageChanged,this,&PosApplication::updateAppLanguage);
    m_engine->setNetworkAccessManagerFactory(new AppQmlNetworkAccessManagerFactory);
    NumberEditor *nb=new NumberEditor(this);
    ReceiptGenerator *gen=new ReceiptGenerator(this);

    m_engine->rootContext()->setContextProperty("App",this);
    m_engine->rootContext()->setContextProperty("AuthManager",AuthManager::instance());
    m_engine->rootContext()->setContextProperty("NetworkManager",PosNetworkManager::instance());
    m_engine->rootContext()->setContextProperty("NumberEditor",nb);
    m_engine->rootContext()->setContextProperty("ReceiptGenerator",gen);
    m_engine->rootContext()->setContextProperty("Api",Api::instance());
    m_engine->rootContext()->setContextProperty("Settings",AppSettings::instance());
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

QVariantList PosApplication::languages() const
{
    QVariantList list;
    list << QVariantMap{{"key","American English"},{"value",QLocale::English}};
    for(const QTranslator *translator : m_translators){
        QLocale locale(translator->language());
        list << QVariantMap{{"key",locale.nativeLanguageName()},{"value",locale.language()}};
    }
    return list;
}

QList<QLocale> PosApplication::locales() const
{
    QList<QLocale>  list;
    list << QLocale(QLocale::English);
    for(const QTranslator *translator : m_translators){
        list << QLocale(translator->language());

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
        }
    }
}

QLocale::Language PosApplication::language() const
{
    return AppSettings::instance()->language();
}

void PosApplication::setLanguage(const QLocale::Language newLanguage)
{
    if (language() == newLanguage)
        return;
    AppSettings::instance()->setLanguage(newLanguage);
    emit languageChanged();
}

void PosApplication::updateAppLanguage()
{
    QTranslator *translator=nullptr;
    for(QTranslator *item : m_translators){
        if(QLocale(item->language()).language()==language()){
            translator=item;
        }
    }
    if(translator){
        QCoreApplication::installTranslator(translator);
        if(language()==QLocale::Arabic){
            AppSettings::instance()->setFont("STV");
            this->updateAppFont();
        }
    }
    else if
        (language()==QLocale::English){
            for(QTranslator *item : m_translators){
                QCoreApplication::removeTranslator(item);
            }
        }

    m_engine->setUiLanguage(QLocale(language()).name());
    m_engine->retranslate();
    setLayoutDirection(QLocale(language()).textDirection());
}

void PosApplication::updateAppFont()
{
    QFont font=this->font();
    font.setFamily(AppSettings::instance()->font());
    this->setFont(font);
}

QStringList PosApplication::availablePrinters()
{
    QStringList printers = QPrinterInfo::availablePrinterNames();
    printers.prepend("Default Printer");
    return printers;
}
