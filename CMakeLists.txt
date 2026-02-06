cmake_minimum_required(VERSION 3.16)
project(appposfe VERSION 30 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)
set(QT_ANDROID_EXTRA_PLUGINS "${CMAKE_CURRENT_SOURCE_DIR}/plugins")

#set(ALLOW_DUPLICATE_CUSTOM_TARGETS true)
add_compile_definitions(APP_VERSION=${PROJECT_VERSION})

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2  Multimedia Gui Network Charts Svg Core5Compat Widgets PrintSupport Location Positioning LinguistTools)

if((NOT ANDROID) AND (NOT IOS) AND (NOT EMSCRIPTEN))
find_package(Qt6  COMPONENTS Pdf REQUIRED)
find_package(Qt6  COMPONENTS SerialPort  REQUIRED)
endif()


set(ENABLE_QML ON)

add_subdirectory(libs/network-manager)
add_subdirectory(libs/CoreUI-QML)
add_subdirectory(libs/QGumboParser)
add_subdirectory(libs/SCodes/src)
add_subdirectory(app)


#list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/src")
list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/qml" )

list(REMOVE_DUPLICATES QML_DIRS)
set(QML_IMPORT_PATH ${QML_DIRS}
    CACHE STRING "Qt Creator 4.1 extra qml import paths"
    FORCE
)

add_custom_target(dist_files
SOURCES
dist/windows/install.nsi
)
