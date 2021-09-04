#include <posapplication.h>
#include <QSettings>
#include <mainwindow.h>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "authmanager.h"
#include "models/productsmodel.h"
#include "models/ordersmodel.h"
#include "models/orderitemsmodel.h"
#include "models/cashiermodel.h"
#include "models/categoriesmodel.h"
#include "posnumpadwidget/utils/numbereditor.h"
#include "models/jsonModel/treeproxymodel.h"
#include "models/taxescheckablemodel.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("sadeqTech");
    QCoreApplication::setApplicationName("pos-fe");
    QSettings settings;
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    PosApplication a(argc, argv);
    //a.setStyle("Breeze");



//   QGuiApplication a(argc, argv);
    QQmlApplicationEngine engine;
    NumberEditor nb;
    engine.rootContext()->setContextProperty("AuthManager",AuthManager::instance());
    engine.rootContext()->setContextProperty("NetworkManager",PosNetworkManager::instance());
    engine.rootContext()->setContextProperty("NumberEditor",&nb);


    qmlRegisterType<ProductsModel>("app.models", 1, 0, "ProductsModel");
    qmlRegisterType<OrdersModel>("app.models", 1, 0, "OrdersModel");
    qmlRegisterType<OrderItemsModel>("app.models", 1, 0, "OrderItemsModel");
    qmlRegisterType<CashierModel>("app.models", 1, 0, "CashierModel");
    qmlRegisterType<CategoriesModel>("app.models", 1, 0, "CategoriesModel");
    qmlRegisterType<TreeProxyModel>("app.models", 1, 0, "TreeProxyModel");
    qmlRegisterType<TaxesCheckableModel>("app.models", 1, 0, "TaxesCheckableModel");







    //instances should be added before engine.load
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return a.exec();
}
