cmake_minimum_required(VERSION 3.16)
project(pos-fe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
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
find_package(Qt6  COMPONENTS LinguistTools)

add_subdirectory(network-manager/src)
add_subdirectory(json-model/src)

add_subdirectory(pos-fe)


target_link_libraries(pos-fe PRIVATE network-manager)
target_link_libraries(pos-fe PRIVATE json-model)
