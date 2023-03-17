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
import PosFe
ListView {
    id: view
    clip: true
    Layout.fillHeight: true
    section.property: "category"
    section.delegate: Label {
        padding: 10
        text: section
        font.bold: true
    }



    topMargin: CoreUI.borderRadius
    bottomMargin: CoreUI.borderRadius
    property int dragItemIndex: -1
    ScrollBar.vertical: ScrollBar {}
    Layout.preferredWidth: 300
    Layout.preferredHeight: 300


    Rectangle {
        parent: view
        border.color: view.palette.shadow
        radius: CoreUI.borderRadius
        anchors.fill: parent
        color: dropArea.containsDrag ? "#0F0000FF" : "transparent"
    }

    model: []

    DropArea {
        id: dropArea
        parent: view
        anchors.fill: parent
        keys: ["application/json"]
        onDropped: drop => {
                       if (drop.source !== view) {
                           model.appendRecord(JSON.parse(
                                                     drop.getDataAsString(
                                                         "application/json")))
                           drop.acceptProposedAction()
                           view.positionViewAtEnd()
                       } else {
                           drop.accept(Qt.IgnoreAction)
                       }
                   }
    }

    spacing: -1 * CoreUI.borderWidth
    reuseItems: false

    delegate: CItemDelegate {
        id: dragDelegate
        text: model.permission
        width: ListView.view.width
        background: Rectangle {
            color: dragDelegate.highlighted ? dragDelegate.palette.active.highlight : dragDelegate.isCurrentItem ? //hovered?
                                                                                                                   dragDelegate.palette.dark : dragDelegate.palette.base
        }
        Drag.active: dragArea.drag.active
        Drag.onActiveChanged: {
            if (Drag.active) {
                dragDelegate.grabToImage(function (result) {
                    dragDelegate.Drag.imageSource = result.url
                    Drag.startDrag()
                })
            }
        }


        Drag.hotSpot.x: dragDelegate.width / 4
        Drag.hotSpot.y: dragDelegate.height / 4
        Drag.dragType: Drag.None
        Drag.supportedActions: Qt.MoveAction | Qt.IgnoreAction
        Drag.proposedAction: Qt.MoveAction
        Drag.source: view
        Drag.mimeData: {
            "application/json": JSON.stringify(view.model.jsonObject(index))
        }

        Drag.onDragFinished: action => {
                                 if (action === Qt.MoveAction) {
                                     view.model.removeRecord(index)
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
                    opacity: 0.5
                    x: 0
                    y: 0
                    //                                z: 100
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
