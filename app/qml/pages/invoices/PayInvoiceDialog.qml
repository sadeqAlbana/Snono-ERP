import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

// Settles an existing invoice via POST /invoice/pay. Caller sets invoiceId + balanceDue
// (and optionally customerName for display), then calls open(). Emits `paid()` on success
// so the parent page can refresh.
AppDialog {
    id: dialog

    property int    invoiceId: 0
    property real   balanceDue: 0
    property string customerName: ""

    signal paid()

    width:  parent ? parent.width  * 0.4 : 440
    height: parent ? parent.height * 0.5 : 360

    function _amount() { return parseFloat(amountTF.input.text) || 0 }

    function _submit() {
        NetworkManager.post("/invoice/pay", {
            "invoice_id":        dialog.invoiceId,
            "payment_method_id": methodCB.currentValue,
            "amount":            dialog._amount()
        }).subscribe(function (res) {
            let reply = res.json()
            if (reply.status === 200) {
                toastrService.push(qsTr("Paid"),
                                   reply.message ?? qsTr("Payment recorded"),
                                   "success", 2000)
                dialog.paid()
                dialog.close()
            }
            // Non-200 surfaces via PosNetworkManager's apiReply hook already.
        })
    }

    onOpened: {
        // Refresh available methods every open in case admin tweaked them. Filter to
        // cash/bank — COD is rejected server-side, credit isn't a real method anymore.
        NetworkManager.post("/paymentMethods", {}).subscribe(function (res) {
            let methods = res.json("data") || []
            methodCB.model = methods.filter(function (m) {
                return m.enabled && (m.type === "cash" || m.type === "bank")
            })
        })
        amountTF.input.text = dialog.balanceDue
    }

    Card {
        title: qsTr("Pay Invoice")
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                visible: dialog.customerName.length > 0
                CLabel { text: qsTr("Customer");    font.bold: true; Layout.preferredWidth: 130 }
                CLabel { text: dialog.customerName; Layout.fillWidth: true }
            }

            RowLayout {
                Layout.fillWidth: true
                CLabel { text: qsTr("Balance Due"); font.bold: true; Layout.preferredWidth: 130 }
                CLabel { text: Utils.formatCurrency(dialog.balanceDue); font.bold: true }
            }

            CLabel { text: qsTr("Pay with"); Layout.topMargin: 6 }
            CComboBox {
                id: methodCB
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
            }

            CTextFieldGroup {
                id: amountTF
                label.text: qsTr("Amount")
                Layout.fillWidth: true
                input.text: dialog.balanceDue
                input.validator: DoubleValidator { bottom: 0.01; top: dialog.balanceDue }
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
                text: qsTr("Pay")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                implicitWidth: 100
                Layout.margins: 10
                enabled: methodCB.currentValue !== undefined &&
                         dialog._amount() > 0 &&
                         dialog._amount() <= dialog.balanceDue
                onClicked: dialog._submit()
            }
        }
    }
}
