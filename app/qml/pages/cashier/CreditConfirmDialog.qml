import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

// Confirms a buy-on-credit sale before posting it. Skipped for cash sales (PayDialog
// already serves as their confirmation step). Same signal-and-close shape as PayDialog
// so the caller's onAccepted handler stays uniform.
AppDialog {
    id: dialog

    property real amount: 0
    property string customerName: ""

    signal accepted()

    width:  parent ? parent.width  * 0.4 : 420
    height: parent ? parent.height * 0.35 : 240

    Card {
        title: qsTr("Confirm Credit Sale")
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            CLabel {
                text: qsTr("This sale will be booked as an outstanding invoice. " +
                           "No payment will be recorded — the customer owes the full amount.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                CLabel { text: qsTr("Customer"); font.bold: true; Layout.preferredWidth: 100 }
                CLabel { text: dialog.customerName; Layout.fillWidth: true }
            }
            RowLayout {
                Layout.fillWidth: true
                CLabel { text: qsTr("Amount");   font.bold: true; Layout.preferredWidth: 100 }
                CLabel { text: Utils.formatCurrency(dialog.amount); Layout.fillWidth: true }
            }
        }

        footer: RowLayout {
            Rectangle { color: "transparent"; Layout.fillWidth: true }

            CButton {
                text: qsTr("Cancel")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                implicitWidth: 100
                Layout.margins: 10
                onClicked: dialog.close()
            }
            CButton {
                text: qsTr("Confirm")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                implicitWidth: 100
                Layout.margins: 10
                onClicked: {
                    dialog.accepted()
                    dialog.close()
                }
            }
        }
    }
}
