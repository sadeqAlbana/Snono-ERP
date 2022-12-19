import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt.labs.qmlmodels
import CoreUI.Forms
import QtQuick.Layouts
Container {
    id: container
    anchors.fill: parent

    property var model: [{
            "type": "text",
            "key": "username",
            "label": qsTr("Username")
        }, {
            "type": "spinbox",
            "key": "month",
            "label": qsTr("Month")
        }]
    contentItem: GridView {
        model: container.contentModel
    }

    Repeater {
        model: container.model
        delegate: Repeater {
            model: [{
                    "type": "label",
                    "label": modelData.label
                }, modelData]

            delegate: DelegateChooser {
                role: "type"
                DelegateChoice {
                    roleValue: "text"
                    TextField {
                        required property var modelData
                        width: 100
                        height: 50
                    }
                }
                DelegateChoice {
                    roleValue: "label"
                    Label {
                        required property var modelData

                        text: modelData.label
                    }
                }
                DelegateChoice {

                    roleValue: "spinbox"
                    SpinBox {
                        required property var modelData

                    }
                }
            }
        }
    }
}


