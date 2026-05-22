import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import JsonModels

AppPage {
    id: page
    title: qsTr("Invoice Details")

    // Set by Router.navigate from InvoicesPage
    property var keyValue
    property var invoice: ({})

    function _reload() {
        if (page.keyValue === undefined) return
        NetworkManager.post("/invoice/info", { "id": page.keyValue }).subscribe(function (res) {
            let r = res.json()
            if (r.status === 200) {
                page.invoice = r.invoice
            }
        })
    }
    Component.onCompleted: _reload()

    PayInvoiceDialog {
        id: payDialog
        onPaid: page._reload()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        GridLayout {
            columns: 4
            columnSpacing: 20

            CLabel { text: qsTr("ID");          font.bold: true }
            CLabel { text: page.invoice?.id ?? "" }
            CLabel { text: qsTr("Status");      font.bold: true }
            CLabel { text: page.invoice?.status ?? "" }

            CLabel { text: qsTr("Customer");    font.bold: true }
            CLabel { text: page.invoice?.party?.name ?? "" }
            CLabel { text: qsTr("Total");       font.bold: true }
            CLabel { text: Utils.formatCurrency(page.invoice?.total ?? 0) }

            CLabel { text: qsTr("Date");        font.bold: true }
            CLabel { text: page.invoice?.date ?? "" }
            CLabel { text: qsTr("Balance Due"); font.bold: true }
            CLabel { text: Utils.formatCurrency(page.invoice?.balance_due ?? 0) }
        }

        CButton {
            text: qsTr("Pay")
            palette.button: "#2eb85c"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            implicitWidth: 140
            Layout.topMargin: 10
            enabled: AuthManager.hasPermission("prm_pay_invoice") &&
                     (parseFloat(page.invoice?.balance_due ?? 0)) > 0
            onClicked: {
                payDialog.invoiceId    = page.invoice.id
                payDialog.balanceDue   = parseFloat(page.invoice.balance_due)
                payDialog.customerName = page.invoice?.party?.name ?? ""
                payDialog.open()
            }
        }

        CLabel { text: qsTr("Lines");    font.bold: true; Layout.topMargin: 12 }
        CTableView {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            rowHeightProvider: function (row) { return 50 }
            delegate: AppDelegateChooser {}
            model: JsonModel {
                columnList: [
                    JsonModelColumn { displayName: qsTr("Description"); key: "description"; type: "text" },
                    JsonModelColumn { displayName: qsTr("Qty");         key: "qty";         type: "number" },
                    JsonModelColumn { displayName: qsTr("Unit Price");  key: "unit_price";  type: "currency" },
                    JsonModelColumn { displayName: qsTr("Total");       key: "total";       type: "currency" }
                ]
                records: page.invoice?.lines ?? []
            }
        }

        CLabel { text: qsTr("Payments"); font.bold: true; Layout.topMargin: 12 }
        CTableView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            rowHeightProvider: function (row) { return 50 }
            delegate: AppDelegateChooser {}
            model: JsonModel {
                columnList: [
                    JsonModelColumn { displayName: qsTr("Date");   key: "date";   type: "datetime" },
                    JsonModelColumn {
                        displayName: qsTr("Method")
                        key: "name"
                        parentKey: "payment_method"
                        type: "text"
                    },
                    JsonModelColumn { displayName: qsTr("Amount"); key: "amount"; type: "currency" },
                    JsonModelColumn { displayName: qsTr("Status"); key: "status"; type: "text" }
                ]
                records: page.invoice?.payments ?? []
            }
        }
    }
}
