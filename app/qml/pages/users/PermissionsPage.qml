import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import JsonModels
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
                clip: true
                topMargin: CoreUI.borderRadius
                bottomMargin: CoreUI.borderRadius
                property int dragItemIndex: -1
                ScrollBar.vertical: ScrollBar { }
                Layout.preferredWidth: 300
                Layout.preferredHeight: 300

//                move: Transition {
//                    NumberAnimation { properties: "x,y"; duration: 1000 }
//                }

//                populate: Transition {
//                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 1000 }
//                }

//                remove: Transition {
//                    ParallelAnimation {
//                        NumberAnimation { property: "opacity"; to: 0; duration: 1000 }
//                        //NumberAnimation { properties: "x,y"; to: 100; duration: 1000 }
//                    }
//                }


                Rectangle {
                    parent: view
                    border.color: view.palette.shadow
                    radius: CoreUI.borderRadius
                    anchors.fill: parent
                    color: dropArea.containsDrag ? "#0FFF0000" : "transparent"
                }

                DropArea {
                    id: dropArea
                    parent: view
                    anchors.fill: parent
                    keys: ["application/json"]
                    onDropped: drop => {
                                   if(drop.source!==view){
                                       aclModel.appendRecord(JSON.parse(drop.getDataAsString("application/json")))
                                       drop.acceptProposedAction();
                                       view.positionViewAtEnd();

                                   }else{
                                       drop.accept(Qt.IgnoreAction)
                                   }
                               }


                }

                model: AclItemsModel{
                    id: aclModel
                }

                spacing: -1*CoreUI.borderWidth
                delegate: CItemDelegate {
                    id: dragDelegate
                    text: model.permission
                    width: ListView.view.width
                    background: Rectangle{

                        color: dragDelegate.highlighted? dragDelegate.palette.active.highlight :
                                                      dragDelegate.isCurrentItem? //hovered?
                                                      dragDelegate.palette.dark
                        :      dragDelegate.palette.base
                        //border.color: dragDelegate.palette.shadow
                        //border.width: CoreUI.borderWidth
                    }
                    Drag.active: dragArea.drag.active
                    Drag.onActiveChanged: {
                        console.log("drag started")
                        dragDelegate.grabToImage(function(result){
                        dragDelegate.Drag.imageSource=result.url
                        Drag.startDrag();
                        });
                    }

                    Drag.hotSpot.x: dragDelegate.width / 2
                    Drag.hotSpot.y: dragDelegate.height / 2
                    Drag.dragType: Drag.None
                    Drag.supportedActions: Qt.MoveAction | Qt.IgnoreAction
                    Drag.proposedAction: Qt.MoveAction
                    Drag.source: view
                    Drag.mimeData: {
                        "application/json": JSON.stringify(aclModel.jsonObject(index))

                    }

                    Drag.onDragFinished: action=> {
                                             if(action===Qt.MoveAction){
                                                 aclModel.removeRecord(index)
                                             }

                    }

                    states: [
                        State {
                            when: dragArea.drag.active

                            AnchorChanges {
                                target: dragDelegate
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                            PropertyChanges {
                                target: dragDelegate
                                x: 0
                                y: 0
                                z: 100
//                                parent: view.parent
                                restoreEntryValues: true

                            }
                        }
                    ]

                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        drag.target: dragDelegate
                        Drag.keys: ["permission"]




                    }
                } //delegate

            } //ListView
        } //component

        Repeater {
            model: 2
            delegate: scene
        }
    } //ColumnLayout end
} //card end
