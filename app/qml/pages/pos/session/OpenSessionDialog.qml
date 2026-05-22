import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppDialog {
    id: dialog

    // Emitted on confirm with the counted opening_balance (number, may be 0).
    signal accepted(real openingBalance)

    width:  parent ? parent.width  * 0.35 : 400
    height: parent ? parent.height * 0.35 : 260

    function _value() { return parseFloat(openingBalanceTF.input.text) || 0 }

    Card {
        title: qsTr("Open POS Session")
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 12

            CLabel {
                text: qsTr("Count the cash currently in the drawer and enter the total below. " +
                           "This becomes the session's opening balance.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            CTextFieldGroup {
                id: openingBalanceTF
                label.text: qsTr("Opening balance")
                Layout.fillWidth: true
                input.text: "0"
                input.validator: DoubleValidator { bottom: 0; top: 1e10 }
                Component.onCompleted: input.forceActiveFocus()
            }
        }

        footer: RowLayout {
            Rectangle { color: "transparent"; Layout.fillWidth: true }

            CButton {
                text: qsTr("Cancel")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                implicitWidth: 100
                Layout.margins: 10
                onClicked: dialog.close()
            }
            CButton {
                text: qsTr("Open")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                implicitWidth: 100
                Layout.margins: 10
                onClicked: {
                    dialog.accepted(dialog._value())
                    dialog.close()
                }
            }
        }
    }
}
