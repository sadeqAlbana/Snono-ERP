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



            ListView {
                id: view
                Layout.preferredWidth: 300
                Layout.preferredHeight: 300
                Rectangle{
                    parent: view
                    border.color: "black"
                    color: "transparent";
                    z: -1
                    anchors.fill: parent;

                }


                model:     ListModel {
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

                delegate: ItemDelegate{
                    text: model.name

                    MouseArea{
                        anchors.fill: parent
                        drag.target: parent
                        Drag.keys: [ "red" ]


                    }

                }

                spacing: 4
                cacheBuffer: 50
            }


    }//ColumnLayout end




}//card end

