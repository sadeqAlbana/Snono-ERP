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

//https://raymii.org/s/tutorials/Qml_Drag_and_Drop_example_including_reordering_the_Cpp_Model.html
//https://stackoverflow.com/questions/36449029/how-to-drag-an-item-outside-a-listview-in-qml
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
                property int dragItemIndex: -1

                Layout.preferredWidth: 300
                Layout.preferredHeight: 300
                Rectangle {
                    parent: view
                    border.color: "black"
                    anchors.fill: parent
                    color: dropArea.containsDrag ? "#0FFF0000" : "transparent"
                }

                DropArea {
                    id: dropArea
                    parent: view
                    anchors.fill: parent

                    onDropped: drop => {
                                   view.model.append(view.model.get(view.dragItemIndex))
                                   view.dragItemIndex = -1;
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

                    Drag.hotSpot.x: dragDelegate.width / 2
                    Drag.hotSpot.y: dragDelegate.height / 2

                    states: [
                        State {
                            when: dragArea.Drag.active
//                            ParentChange {
//                                target: dragRect
//                                parent: root
//                            }

                            AnchorChanges {
                                target: dragDelegate
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]

                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        drag.target: parent
                        Drag.keys: ["red"]

//                        Drag.onDragFinished: {
//                            console.log("drag finished")
//                        }

//                        onReleased: {
//                            console.log("released !")
//                            //petsModel.remove(index,1);
//                            dragDelegate.Drag.drop()
//                            if (dragDelegate.Drag.target !== null) {
//                                //                            dragDelegate.parent=dragDelegate.Drag.target
//                                console.log("parent changed !")
//                            }
//                        }

                        drag.onActiveChanged: {
                            if (dragArea.drag.active) {
                                view.dragItemIndex = index;
                                view.model.remove(view.dragItemIndex)

                            }
                            dragDelegate.Drag.drop();
                        }



                    }
                } //delegate

                spacing: 4
            } //ListView
        } //component

        Repeater {
            model: 2
            delegate: scene
        }
    } //ColumnLayout end
} //card end
