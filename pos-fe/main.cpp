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
#include <printer/epsonprinter.h>
#include "printer/cepsonesccontrol.h"
#include <QPrinterInfo>
#include <QIcon>
#include "possettings.h"
#include "models/appnetworkedjsonmodel.h"
#include "appqmlnetworkaccessmanagerfactory.h"
#include <QClipboard>
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("com");
    QCoreApplication::setOrganizationDomain("sadeqTech");
    QCoreApplication::setApplicationName("pos_fe");
    //settings.setValue("http_server_url","http://naaom.net:8000");
    //settings.setValue("http_server_url","http://127.0.0.1:8000");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    PosApplication a(argc, argv);
    PosSettings settings;

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

    //qmlRegisterType<TestPalette>("test.palettes", 1, 0, "TestPalette");

//    QPrinter printer(QPrinter::HighResolution);
//    printer.setPrinterName("POS-80(copy of 2)");
//    QPrinterInfo info(printer);
//    qDebug()<<printer.width();
//    qDebug()<<info.defaultPageSize();
//    qDebug()<<info.supportedResolutions();
//    auto sizes =info.supportedPageSizes();
//    for(auto size : sizes){
//        qDebug()<<size;
//    }
//    //EpsonPrinter *printer = new EpsonPrinter();

//    qDebug()<<"count: "<<QSerialPortInfo::availablePorts().count();

    //qDebug()<<"available: "<<QPrinterInfo::availablePrinterNames();

//    QTimer timer;
//    timer.singleShot(5000,[](){

////        QJsonDocument doc=QJsonDocument::fromJson(R"({"cart_id":5,"created_at":"2021-12-19T12:55:24.000","customer_id":1,"customers":{"account_id":1001,"address":"N.A","created_at":"2021-12-16T10:37:31.000","deleted_at":"","email":"N.A","first_name":"N.A","id":1,"last_name":"N.A","name":"Customer","phone":"N.A","updated_at":""},"date":"2021-12-19T12:55:24.000","deleted_at":"","id":2,"journal_entry_id":55,"paid_amount":19087.5,"pos_order_items":[{"created_at":"2021-12-19T12:55:24.000","deleted_at":"","discount":0,"id":2,"order_id":2,"product_id":42,"products":{"barcode":"sw2106259185997506-l","category_id":1,"cost":10725,"costing_method":"FIFO","created_at":"2021-12-16T10:37:37.000","current_cost":10725,"deleted_at":"","description":"","flags":0,"id":42,"list_price":19087.5,"name":"SHEIN فستان نوم كامي زين تفاصيل حافة منديل شبكة - L","parent_id":0,"type":1,"updated_at":"2021-12-16T10:37:37.000"},"qty":1,"subtotal":19087.5,"total":19087.5,"unit_price":19087.5,"updated_at":"2021-12-19T12:55:24.000"}],"pos_session_id":1,"reference":"3dcc3168-0488-40c0-81dd-a4d1cd11b1d3","returned_amount":0,"tax_amount":0,"total":19087.5,"updated_at":"2021-12-19T12:55:24.000"})");
//        CEpsonEscControl *m_ctrl=new CEpsonEscControl();
//        m_ctrl->setPortName("COM1");
//        if(!m_ctrl->openSerialPort(QSerialPort::WriteOnly)) {
//            qDebug() << "open fails";
//        }
//        int sendBytes = m_ctrl->
//                c_init()
//                .c_addFont("im mark")
//                .c_objLayout('c')
//                .c_beginFontSize(2)
//                .c_addFont("big font")
//                .c_endFontSize()
//                .c_lineSpace_b(2)
//                .c_addFont("hello!!")
//                .c_cutPaper(false,1,20)
//                .sendBufferToPrinter();
//        qDebug() << "actual send = " << sendBytes;

//    });





    //instances should be added before engine.load
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return a.exec();
}
