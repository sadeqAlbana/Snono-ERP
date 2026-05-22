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

    // Inputs from caller
    property int  sessionId
    property real expectedBalance: 0   // session.cashBalance() from backend — opening + cash_in − cash_out

    // Emitted on confirm
    signal accepted(int sessionId, real closingBalance, real depositAmount)

    width:  parent ? parent.width  * 0.45 : 520
    height: parent ? parent.height * 0.55 : 480

    readonly property real countedBalance: parseFloat(closingTF.input.text) || 0
    readonly property real depositValue:   parseFloat(depositTF.input.text) || 0
    readonly property real variance:       countedBalance - expectedBalance
    readonly property real carryForward:   Math.max(0, countedBalance - depositValue)
    readonly property bool depositValid:   depositValue >= 0 && depositValue <= countedBalance

    Card {
        title: qsTr("Close POS Session")
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                CLabel { text: qsTr("Expected"); Layout.fillWidth: true }
                CLabel { text: Utils.formatCurrency(dialog.expectedBalance); font.bold: true }
            }

            CTextFieldGroup {
                id: closingTF
                label.text: qsTr("Counted cash in drawer")
                Layout.fillWidth: true
                input.text: dialog.expectedBalance
                input.validator: DoubleValidator { bottom: 0; top: 1e10 }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: Math.abs(dialog.variance) > 0.0001
                CLabel {
                    text: dialog.variance > 0 ? qsTr("Overage") : qsTr("Shortage")
                    color: dialog.variance > 0 ? "#2eb85c" : "#e55353"
                    Layout.fillWidth: true
                }
                CLabel {
                    text: Utils.formatCurrency(Math.abs(dialog.variance))
                    color: dialog.variance > 0 ? "#2eb85c" : "#e55353"
                    font.bold: true
                }
            }

            CTextFieldGroup {
                id: depositTF
                label.text: qsTr("Deposit amount")
                Layout.fillWidth: true
                input.text: dialog.expectedBalance
                input.validator: DoubleValidator { bottom: 0; top: 1e10 }
            }

            CLabel {
                text: qsTr("Carry forward (stays in drawer): %1").arg(Utils.formatCurrency(dialog.carryForward))
                Layout.fillWidth: true
            }

            CLabel {
                visible: !dialog.depositValid
                color: "#e55353"
                text: qsTr("Deposit must be between 0 and counted cash.")
                Layout.fillWidth: true
                wrapMode: Text.Wrap
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
                text: qsTr("Close session")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                implicitWidth: 130
                Layout.margins: 10
                enabled: dialog.depositValid
                onClicked: {
                    dialog.accepted(dialog.sessionId, dialog.countedBalance, dialog.depositValue)
                    dialog.close()
                }
            }
        }
    }
}
