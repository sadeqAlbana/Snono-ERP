
if(ANDROID)
    add_compile_definitions(QT_NO_PDF TRUE)
endif()

    set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/icons/appposfe.rc")
qt_add_executable(appposfe
    appsettings.cpp appsettings.h
    posnetworkmanager.cpp posnetworkmanager.h
    receiptgenerator.cpp receiptgenerator.h
    authmanager.cpp authmanager.h
    posapplication.cpp posapplication.h
    code128.cpp code128.h
    code128item.cpp code128item.h
    appqmlnetworkaccessmanagerfactory.cpp appqmlnetworkaccessmanagerfactory.h
    api.cpp api.h
    utils.cpp utils.h
    qrcodegen.cpp qrcodegen.hpp
    posnumpadwidget/utils/numbereditor.cpp posnumpadwidget/utils/numbereditor.h
    misc/receipt.qrc
    language/language.qrc
    images.qrc
    fonts/fonts.qrc
    qrc.qrc
    main.cpp

    ${app_icon_resource_windows}
)



qt_add_qml_module(appposfe
    URI "PosFe"
    VERSION 1.0
    SOURCES
        models/appnetworkedjsonmodel.cpp models/appnetworkedjsonmodel.h
        models/accountsmodel.cpp models/accountsmodel.h
        models/barqlocationsmodel.cpp models/barqlocationsmodel.h
        models/cashiermodel.cpp models/cashiermodel.h
        models/categoriesmodel.cpp models/categoriesmodel.h
        models/customersmodel.cpp models/customersmodel.h
        models/customvendorcartmodel.cpp models/customvendorcartmodel.h
        models/journalentriesmodel.cpp models/journalentriesmodel.h
        models/journalentriesitemsmodel.cpp models/journalentriesitemsmodel.h
        models/ordersmodel.cpp models/ordersmodel.h
        models/orderitemsmodel.cpp models/orderitemsmodel.h
        models/orderreturnitemsmodel.cpp models/orderreturnitemsmodel.h
        models/ordersreturnsmodel.cpp models/ordersreturnsmodel.h
        models/possessionsmodel.cpp models/possessionsmodel.h
        models/productsalesreportmodel.cpp models/productsalesreportmodel.h
        models/productsattributesattributesmodel.cpp models/productsattributesattributesmodel.h
        models/productsmodel.cpp models/productsmodel.h
        models/receiptmodel.cpp models/receiptmodel.h
        models/returnordermodel.cpp models/returnordermodel.h
        models/stockreportmodel.cpp models/stockreportmodel.h
        models/taxescheckablemodel.cpp models/taxescheckablemodel.h
        models/taxesmodel.cpp models/taxesmodel.h
        models/usersmodel.cpp models/usersmodel.h
        models/vendorcartmodel.cpp models/vendorcartmodel.h
        models/vendorsbillsmodel.cpp models/vendorsbillsmodel.h
        models/vendorsmodel.cpp models/vendorsmodel.h
        models/charts/saleschartmodel.cpp models/charts/saleschartmodel.h
        models/jsonModel/checkablelistmodel.cpp models/jsonModel/checkablelistmodel.h
        models/jsonModel/treeproxymodel.cpp models/jsonModel/treeproxymodel.h

    QML_FILES
    qml/pages/pos/session/SessionsPage.qml
    qml/pages/pos/session/SessionCard.qml
    qml/pages/taxes/TaxTypeDelegate.qml
    qml/pages/taxes/TaxesPage.qml
    qml/pages/taxes/AddTaxPage.qml
    qml/pages/users/UsersPage.qml
    qml/pages/LoginPage.qml
    qml/pages/ReceiptPage.qml
    qml/pages/Accounting/DepositMoneyDialog.qml
    qml/pages/Accounting/InternalTypeDelegate.qml
    qml/pages/Accounting/JournalEntriesItemsPage.qml
    qml/pages/Accounting/JournalEntriesPage.qml
    qml/pages/Accounting/AccountsPage.qml
    qml/pages/Accounting/TypeDeleagate.qml
    qml/pages/orders/OrderReturnDialog.qml
    qml/pages/orders/OrderReturnListView.qml
    qml/pages/orders/OrdersPage.qml
    qml/pages/orders/UpdateDeliveryStatusDialog.qml
    qml/pages/orders/OrderDetails.qml
    qml/pages/orders/OrdersReturnsPage.qml
    qml/pages/orders/OrderStatusDelegate.qml
    qml/pages/ServerSettingsDialog.qml
    qml/pages/reports/ProductSalesReport.qml
    qml/pages/reports/StockReport.qml
    qml/pages/products/ProductsPage.qml
    qml/pages/products/ProductPurchaseStockDialog.qml
    qml/pages/products/ProductsMobilePage.qml
    qml/pages/products/ProductEditDialog.qml
    qml/pages/products/ProductAddDialog.qml
    qml/pages/products/AdjustStockDialog.qml
    qml/pages/cashier/CashierPage.qml
    qml/pages/cashier/Numpad.qml
    qml/pages/cashier/NumpadButton.qml
    qml/pages/cashier/PayDialog.qml
    qml/pages/dashboard/DashboardPage.qml
    qml/pages/dashboard/AppDashboardWidget.qml
    qml/pages/dashboard/NewDashboardWidget.qml
    qml/pages/dashboard/DashboardRowItem.qml
    qml/pages/dashboard/DashboardWidgetTable.qml
    qml/pages/customers/AddCustomerDialog.qml
    qml/pages/customers/CustomersPage.qml
    qml/pages/customers/CustomersBillsPage.qml
    qml/pages/categories/CategoriesPage.qml
    qml/pages/categories/AddCategoryDialog.qml
    qml/pages/settings/GeneralSettings.qml
    qml/pages/settings/PrinterSettings.qml
    qml/pages/vendors/VendorBillListView.qml
    qml/pages/vendors/PurchaseStockDialog.qml
    qml/pages/vendors/PayBillDialog.qml
    qml/pages/vendors/StatusDelegate.qml
    qml/pages/vendors/AddCustomBillDialog.qml
    qml/pages/vendors/VendorsBillsPage.qml
    qml/pages/vendors/AddVendorDialog.qml
    qml/pages/vendors/CustomVendorBillListView.qml
    qml/pages/vendors/VendorsPage.qml
    qml/Nav.qml
    qml/AppMainScreen.qml
    qml/common/ButtonPopup.qml
    qml/common/BusySpinner.qml
    qml/common/CurrencyDelegate.qml
    qml/common/ReceiptDialog.qml
    qml/common/AppDialog.qml
    qml/common/Spinner.qml
    qml/common/AppToolBar.qml
    qml/common/AppPage.qml
    qml/common/SuffixDelegate.qml
    qml/common/AppDelegateChooser.qml
    qml/common/TableFilter.qml
    qml/common/DateTimeDelegate.qml
    qml/common/ImageDelegate.qml
    qml/common/CFilterComboBox.qml
    qml/common/DateDelegate.qml
    qml/common/CFilterMenu.qml
    qml/common/DialogFooter.qml
    qml/common/AppDialogFooter.qml
    qml/common/CredentailsTextField.qml
    qml/common/ExternalDeliveryStatusDelegate.qml
    qml/common/LoadingImage.qml
    qml/actions/ChangeLanguageAction.qml
    qml/main.qml
    qml/screens/LoginScreen.qml
    qml/screens/utils.js
    qml/nav.js


)
set(INCLUDE_DIR
    models
    models/charts
    models/jsonModel
    )
target_include_directories(appposfe PUBLIC ${INCLUDE_DIR})


qt_add_translations(appposfe
    TS_FILES language/pos-fe_ar_IQ.ts)



set_target_properties(appposfe PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(ANDROID)
set_target_properties(appposfe PROPERTIES QT_ANDROID_EXTRA_LIBS "${ANDROID_EXTRA_LIBS}")
endif()

target_link_libraries(appposfe PRIVATE Qt6::Quick
    Qt6::Core
    Qt6::Multimedia
    Qt6::Gui
    Qt6::Network
    Qt6::Charts
    Qt6::Svg
    Qt6::Core5Compat
    Qt6::Widgets
    Qt6::PrintSupport
    SNetworkManager
    jsonmodel
    coreuiplugin
)

if(NOT ANDROID)
    target_link_libraries(appposfe PRIVATE Qt6::Pdf Qt6::SerialPort)
endif()

list(APPEND QML_DIRS  "${CMAKE_CURRENT_BINARY_DIR}/qml")


target_compile_definitions(appposfe
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)