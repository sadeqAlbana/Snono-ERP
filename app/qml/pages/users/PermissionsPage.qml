import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import Qt5Compat.GraphicalEffects
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

//https://doc.qt.io/qt-6/qtquick-tutorials-dynamicview-dynamicview2-example.html
import PosFe
AppPage{

    title: qsTr("Permissions")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        Rectangle {
            id: root
            Layout.preferredWidth: 300
            Layout.preferredHeight: 300
            width: 300; height: 400






            ListView {
                id: view

                Rectangle{
                    parent: view
                    border.color: "black"
                    color: "transparent";
                    z: -1
                    anchors.fill: parent;
                }

                anchors { fill: parent; margins: 2 }

                model: petsModel
                delegate: ItemDelegate{

                }

                spacing: 4
                cacheBuffer: 50
            }
        }

    }//ColumnLayout end

    ListModel {
        id: petsModel
        ListElement {
            name: "Polly"
            type: "Parrot"
            age: 12
            size: "Small"
        }
        ListElement {
            name: "Penny"
            type: "Turtle"
            age: 4
            size: "Small"
        }
    }



}//card end

