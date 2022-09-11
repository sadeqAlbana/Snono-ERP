cmake_minimum_required(VERSION 3.16)
project(pos-fe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6  COMPONENTS Core REQUIRED)
find_package(Qt6  COMPONENTS Quick REQUIRED)
find_package(Qt6  COMPONENTS SerialPort  REQUIRED)
find_package(Qt6  COMPONENTS Pdf REQUIRED)
find_package(Qt6  COMPONENTS Multimedia REQUIRED)
find_package(Qt6  COMPONENTS Gui REQUIRED)
find_package(Qt6  COMPONENTS Network REQUIRED)
find_package(Qt6  COMPONENTS Charts REQUIRED)
find_package(Qt6  COMPONENTS Svg REQUIRED)
find_package(Qt6  COMPONENTS Core5Compat REQUIRED)
find_package(Qt6  COMPONENTS Widgets REQUIRED)
find_package(Qt6  COMPONENTS PrintSupport REQUIRED)



qt_add_executable(pos-fe
    pos-fe/main.cpp
    pos-fe/api.cpp pos-fe/api.h
    pos-fe/appsettings.cpp pos-fe/appsettings.h
    pos-fe/posnetworkmanager.cpp pos-fe/posnetworkmanager.h
    pos-fe/authmanager.cpp pos-fe/authmanager.h
    pos-fe/posapplication.cpp pos-fe/posapplication.h
    pos-fe/code128.cpp pos-fe/code128.h
    pos-fe/code128item.cpp pos-fe/code128item.h
    pos-fe/appqmlnetworkaccessmanagerfactory.cpp pos-fe/appqmlnetworkaccessmanagerfactory.h
    pos-fe/api.cpp pos-fe/api.h
    pos-fe/api.cpp pos-fe/api.h
    pos-fe/api.cpp pos-fe/api.h
)

qt_add_qml_module(pos-fe
    URI pos-fe
    VERSION 1.0
    QML_FILES pos-fe/qml/main.qml
)

set_target_properties(pos-fe PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(pos-fe
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)



target_link_libraries(pos-fe PRIVATE Qt6::Quick)
target_link_libraries(pos-fe PRIVATE Qt6::Core)
target_link_libraries(pos-fe PRIVATE Qt6::SerialPort)
target_link_libraries(pos-fe PRIVATE Qt6::Pdf)
target_link_libraries(pos-fe PRIVATE Qt6::Multimedia)
target_link_libraries(pos-fe PRIVATE Qt6::Gui)
target_link_libraries(pos-fe PRIVATE Qt6::Network)
target_link_libraries(pos-fe PRIVATE Qt6::Charts)
target_link_libraries(pos-fe PRIVATE Qt6::Svg)
target_link_libraries(pos-fe PRIVATE Qt6::Core5Compat)
target_link_libraries(pos-fe PRIVATE Qt6::Widgets)
target_link_libraries(pos-fe PRIVATE Qt6::PrintSupport)
target_link_libraries(pos-fe PRIVATE network-manager)
add_subdirectory(network-manager/src)
