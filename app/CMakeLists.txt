
if(ANDROID)
    add_compile_definitions(QT_NO_PDF TRUE)
endif()



qt_add_executable(pos-fe
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
    models/Models
    misc/receipt.qrc
    language/language.qrc
    qml/qml.qrc
    images.qrc
    fonts/fonts.qrc
    coreui-qml/src/CoreUI.qrc
    coreui-qml/assets/assets.qrc
    main.cpp
)



qt_add_translations(pos-fe
    TS_FILES language/pos-fe_ar_IQ.ts)



set_target_properties(pos-fe PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(ANDROID)
set_target_properties(pos-fe PROPERTIES QT_ANDROID_EXTRA_LIBS "${ANDROID_EXTRA_LIBS}")
endif()

target_link_libraries(pos-fe PRIVATE Qt6::Quick)
target_link_libraries(pos-fe PRIVATE Qt6::Core)
target_link_libraries(pos-fe PRIVATE Qt6::Multimedia)
target_link_libraries(pos-fe PRIVATE Qt6::Gui)
target_link_libraries(pos-fe PRIVATE Qt6::Network)
target_link_libraries(pos-fe PRIVATE Qt6::Charts)
target_link_libraries(pos-fe PRIVATE Qt6::Svg)
target_link_libraries(pos-fe PRIVATE Qt6::Core5Compat)
target_link_libraries(pos-fe PRIVATE Qt6::Widgets)
target_link_libraries(pos-fe PRIVATE Qt6::PrintSupport)

if(NOT ANDROID)
    target_link_libraries(pos-fe PRIVATE Qt6::Pdf)
    target_link_libraries(pos-fe PRIVATE Qt6::SerialPort)
endif()


