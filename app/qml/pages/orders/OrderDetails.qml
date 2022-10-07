import QtQuick
import QtQuick.Controls

import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Views
import QtQuick.Layouts
import PosFe

import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels
import "qrc:/PosFe/qml/common"

Popup {
    id: orderDetails

    modal: true
    parent: Overlay.overlay
    margins: 0
    padding: 0
    //width: parent.width
    //height: parent.height
    width: 1000
    height: 500
    anchors.centerIn: parent
    property var order

    //closePolicy: Popup.NoAutoClose
    background: Rectangle {
        color: "transparent"
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
        }
    }

    Card {
        width: 1000
        height: 500
        title: qsTr("Order Details")

        function test(a) {}
        CTableView {
            rowHeightProvider: function (row) {
                return 50
            }
            anchors.fill: parent
            delegate: DelegateChooser {
                role: "delegateType"
                DelegateChoice {
                    roleValue: "text"
                    CTableViewDelegate {}
                }
                DelegateChoice {
                    roleValue: "currency"
                    CurrencyDelegate {}
                }
                DelegateChoice {
                    roleValue: "percentage"
                    SuffixDelegate {
                        suffix: "%"
                    }
                }
            }

            model: OrderItemsModel {
                Component.onCompleted: {
                    setupData(order.pos_order_items)
                }
            }
        }
    }
}
