import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "screens"
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("POS")
    visibility: Window.Maximized

    id: rootItem



    Loader{
        id: rootLoader
        anchors.fill: parent;
//        sourceComponent: LoginScreen{
//            anchors.fill: parent;
//            id: loginScreen
//        }

        sourceComponent: MainScreen{
            anchors.fill: parent;
        }
    }
}