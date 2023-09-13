
if(ANDROID OR IOS OR EMSCRIPTEN)
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

if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/android"
        CACHE INTERNAL "")

    set_target_properties(appposfe PROPERTIES QT_ANDROID_TARGET_SDK_VERSION 33)
    set(android_package_dir "${CMAKE_CURRENT_LIST_DIR}/android/")
    set_target_properties(appposfe PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR
        ${android_package_dir})


    add_custom_target(appposfe_android_package
    SOURCES
    ${android_package_dir}/AndroidManifest.xml
    ${android_package_dir}/build.gradle
#    ${android_package_dir}/settings.gradle
    ${android_package_dir}/gradle.properties
#    ${android_package_dir}/google-services.json
    ${android_package_dir}/res/values/libs.xml
    ${android_package_dir}/res/values/ic_launcher_background.xml
    ${android_package_dir}/res/mipmap-xxxhdpi/ic_launcher.png
    ${android_package_dir}/res/mipmap-xxxhdpi/ic_launcher_round.png
    ${android_package_dir}/res/mipmap-xxhdpi/ic_launcher.png
    ${android_package_dir}/res/mipmap-xxhdpi/ic_launcher_round.png
    ${android_package_dir}/res/mipmap-xhdpi/ic_launcher.png
    ${android_package_dir}/res/mipmap-xhdpi/ic_launcher_round.png
    ${android_package_dir}/res/mipmap-hdpi/ic_launcher.png
    ${android_package_dir}/res/mipmap-hdpi/ic_launcher_round.png
    ${android_package_dir}/res/mipmap-mdpi/ic_launcher.png
    ${android_package_dir}/res/mipmap-mdpi/ic_launcher_round.png
    ${android_package_dir}/res/mipmap-anydpi-v26/ic_launcher.xml
    ${android_package_dir}/res/mipmap-anydpi-v26/ic_launcher_round.xml
    ${android_package_dir}/res/drawable/ic_launcher_foreground.xml
    ${android_package_dir}/res/drawable/ic_launcher_background.xml)
    include(${ANDROID_SDK_ROOT}/android_openssl/CMakeLists.txt)
endif()


set(TARGET_SOURCES
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
    models/aclitemsmodel.h models/aclitemsmodel.cpp
    models/aclgroupsmodel.h models/aclgroupsmodel.cpp
    models/acldndmodel.h models/acldndmodel.cpp
    models/checkableaclitemsmodel.h models/checkableaclitemsmodel.cpp
    models/productattributesproxymodel.h models/productattributesproxymodel.cpp
    models/customjournalentrymodel.h models/customjournalentrymodel.cpp
    models/stocklocationmodel.h models/stocklocationmodel.cpp
    models/stockmovesmodel.h models/stockmovesmodel.cpp
    models/stockvaluationmodel.h models/stockvaluationmodel.cpp
    keyemitter.h keyemitter.cpp
)


set(TARGET_QML_SOURCES
    qml/pages/pos/session/SessionsPage.qml
    qml/pages/pos/session/SessionCard.qml
    qml/pages/taxes/TaxTypeDelegate.qml
    qml/pages/taxes/TaxesPage.qml
    qml/pages/taxes/AddTaxPage.qml
    qml/pages/taxes/TaxForm.qml
    qml/pages/users/UsersPage.qml
    qml/pages/users/UsersForm.qml
    qml/pages/users/PermissionsPage.qml
    qml/pages/users/AclGroupForm.qml
    qml/pages/users/AclGroupsPage.qml
    qml/pages/LoginPage.qml
    qml/pages/ReceiptPage.qml
    qml/pages/Accounting/DepositMoneyDialog.qml
    qml/pages/Accounting/InternalTypeDelegate.qml
    qml/pages/Accounting/JournalEntriesItemsPage.qml
    qml/pages/Accounting/JournalEntriesPage.qml
    qml/pages/Accounting/AccountsPage.qml
    qml/pages/Accounting/TypeDeleagate.qml
    qml/pages/Accounting/JournalEntryForm.qml
    qml/pages/orders/OrderReturnDialog.qml
    qml/pages/orders/OrderReturnListView.qml
    qml/pages/orders/OrdersPage.qml
    qml/pages/orders/UpdateDeliveryStatusDialog.qml
    qml/pages/orders/OrderDetails.qml
    qml/pages/orders/OrdersReturnsPage.qml
    qml/pages/orders/OrderStatusDelegate.qml
    qml/pages/orders/OrderDetailsPage.qml
    qml/pages/orders/ReturnOrderPage.qml
    qml/pages/ServerSettingsDialog.qml
    qml/pages/reports/ProductSalesReport.qml
    qml/pages/reports/StockReport.qml
    qml/pages/products/ProductsPage.qml
    qml/pages/products/ProductPurchaseStockDialog.qml
    qml/pages/products/ProductsMobilePage.qml
    qml/pages/products/ProductEditDialog.qml
    qml/pages/products/ProductAddDialog.qml
    qml/pages/products/AdjustStockDialog.qml
    qml/pages/products/ProductForm.qml
    qml/pages/cashier/CashierPage.qml
    qml/pages/cashier/Numpad.qml
    qml/pages/cashier/NumpadButton.qml
    qml/pages/cashier/PayDialog.qml
    qml/pages/dashboard/DashboardPage.qml
    qml/pages/dashboard/AppDashboardWidget.qml
    qml/pages/dashboard/NewDashboardWidget.qml
    qml/pages/dashboard/DashboardRowItem.qml
    qml/pages/dashboard/DashboardWidgetTable.qml
    qml/pages/customers/AddCustomerPage.qml
    qml/pages/customers/CustomersPage.qml
    qml/pages/customers/CustomersBillsPage.qml
    qml/pages/customers/CustomerForm.qml
    qml/pages/categories/CategoriesPage.qml
    qml/pages/categories/AddCategoryDialog.qml
    qml/pages/settings/GeneralSettings.qml
    qml/pages/settings/IdentitySettings.qml
    qml/pages/settings/PrinterSettings.qml
    qml/pages/settings/BarqDeliverySettings.qml
    qml/pages/settings/ReceiptSettings.qml
    qml/pages/vendors/VendorBillListView.qml
    qml/pages/vendors/PurchaseStockDialog.qml
    qml/pages/vendors/PayBillDialog.qml
    qml/pages/vendors/StatusDelegate.qml
    qml/pages/vendors/AddCustomBillDialog.qml
    qml/pages/vendors/VendorsBillsPage.qml
    qml/pages/vendors/AddVendorDialog.qml
    qml/pages/vendors/CustomVendorBillListView.qml
    qml/pages/vendors/VendorsPage.qml
    qml/pages/vendors/VendorForm.qml
    qml/pages/vendors/AddVendorBillPage.qml
    qml/pages/vendors/AddCustomVendorBillPage.qml
    qml/pages/warehouses/WarehousesPage.qml
    qml/pages/warehouses/StockMovesPage.qml
    qml/pages/warehouses/StockValuationPage.qml
    qml/common/CCheckableFilterComboBox.qml
    qml/Nav.qml
    qml/AppMainScreen.qml
    qml/common/ButtonPopup.qml
    qml/common/BusySpinner.qml
    qml/common/CurrencyDelegate.qml
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
    qml/common/DnDListView.qml
    qml/common/AppDialogFooter.qml
    qml/common/CredentailsTextField.qml
    qml/common/ExternalDeliveryStatusDelegate.qml
    qml/common/LoadingImage.qml
    qml/common/Form.qml
    qml/common/GridContainer.qml
    qml/common/CFormView.qml
    qml/common/AppFormView.qml
    qml/common/AppFormDialog.qml
    qml/common/CTabFormView.qml
    qml/common/ActionsDelegate.qml
    qml/common/PercentageDelegate.qml
    qml/common/LinkDelegate.qml
    qml/common/NumberDelegate.qml
    qml/common/AppProgressBar.qml
    qml/common/DownloadProgressBar.qml
    qml/pages/settings/UpdatesPage.qml
    qml/common/CLinkDelegate.qml

    qml/main.qml
    qml/TestService.qml
    qml/screens/LoginScreen.qml
    qml/screens/utils.js
    qml/nav.js
)

if(ANDROID)
    list(APPEND TARGET_QML_SOURCES
        qml/common/+android/ReceiptDialog.qml)
else()
    list(APPEND TARGET_QML_SOURCES
    qml/common/ReceiptDialog.qml
)

endif()

qt_add_qml_module(appposfe
    URI "PosFe"
    VERSION 1.0
    SOURCES
        ${TARGET_SOURCES}

    QML_FILES
        ${TARGET_QML_SOURCES}
)
set(INCLUDE_DIR
    models
    models/charts
    models/jsonModel
    )
target_include_directories(appposfe PRIVATE ${INCLUDE_DIR})


qt_add_translations(appposfe
    TS_FILES language/pos-fe_ar_IQ.ts)



set_target_properties(appposfe PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.snono.pos_fe
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

if((NOT ANDROID) AND (NOT IOS) AND (NOT EMSCRIPTEN))
    target_link_libraries(appposfe PRIVATE Qt6::Pdf Qt6::SerialPort)
endif()

list(APPEND QML_DIRS  "${CMAKE_CURRENT_BINARY_DIR}/qml")


target_compile_definitions(appposfe
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)


install(TARGETS appposfe
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
