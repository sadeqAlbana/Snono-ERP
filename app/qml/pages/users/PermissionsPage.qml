import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
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

AppPage {

    title: qsTr("Permissions")
    ColumnLayout {
        id: page
        anchors.fill: parent

        Component {
            id: scene
            ListView {
                id: view
                Layout.preferredWidth: 300
                Layout.preferredHeight: 300
                Rectangle {
                    parent: view
                    border.color: "black"
                    anchors.fill: parent
                    color: dropArea.containsDrag? "#0FFF0000": "transparent"

                }

                DropArea {
                    id: dropArea
                    parent: view
                    anchors.fill: parent


                    onDropped:(drop)=>{
                        console.log("dropped !");
                        console.log(drop.keys)
                    }

                    onEntered: {
                        console.log("entered !")
                    }
                }

                model: ListModel {
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



                delegate: ItemDelegate {
                    id: dragDelegate
                    text: model.name
                    Drag.active: dragArea.drag.active
                    Drag.keys: ["blue"]

                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        drag.target: parent
                        Drag.keys: ["red"]

                        onReleased: {
                            console.log("released !")
                            dragDelegate.Drag.drop();
                            if (dragDelegate.Drag.target !== null) {
                                //                            dragDelegate.parent=dragDelegate.Drag.target
                                console.log("parent changed !")
                            }
                        }
                    }
                }//delegate

                spacing: 4


            } //ListView
        }//component

        Repeater{
            model: 2
            delegate: scene
        }
    } //ColumnLayout end
} //card end
