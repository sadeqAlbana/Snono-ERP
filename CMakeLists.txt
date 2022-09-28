cmake_minimum_required(VERSION 3.16)
project(pos-fe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)
if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "app/android"
        CACHE INTERNAL "")
    include(${ANDROID_SDK_ROOT}/android_openssl/CMakeLists.txt)
endif()

find_package(Qt6  COMPONENTS Core REQUIRED)
find_package(Qt6  COMPONENTS Quick REQUIRED)
find_package(Qt6  COMPONENTS Multimedia REQUIRED)
find_package(Qt6  COMPONENTS Gui REQUIRED)
find_package(Qt6  COMPONENTS Network REQUIRED)
find_package(Qt6  COMPONENTS Charts REQUIRED)
find_package(Qt6  COMPONENTS Svg REQUIRED)
find_package(Qt6  COMPONENTS Core5Compat REQUIRED)
find_package(Qt6  COMPONENTS Widgets REQUIRED)
find_package(Qt6  COMPONENTS PrintSupport REQUIRED)
find_package(Qt6  COMPONENTS LinguistTools)
if(NOT ANDROID)
find_package(Qt6  COMPONENTS Pdf REQUIRED)
find_package(Qt6  COMPONENTS SerialPort  REQUIRED)
endif()


add_subdirectory(network-manager/src)
add_subdirectory(json-model/src)
add_subdirectory(libs/CoreUI-QML)
add_subdirectory(app)

list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/qml")
set(QML_IMPORT_PATH "${QML_DIRS}" CACHE STRING "Qt Creator 4.1 extra qml import paths")




