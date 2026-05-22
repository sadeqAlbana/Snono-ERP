import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base
import CoreUI

BasicViewPage {
    id: page
    title: qsTr("Invoices")
    delegate: AppDelegateChooser {

        DelegateChoice {
            roleValue: "InvoiceStatus"
            InvoicePaymentStatusDelegate {}
        }
    }
    model: InvoicesModel {}

    PayInvoiceDialog {
        id: payDialog
        onPaid: page.model.reset()
    }

    actions: [
        CAction {
            text: qsTr("New")
            icon.name: "cil-plus"
            onTriggered: {
                Router.navigate(
                            "qrc:/PosFe/qml/pages/invoices/NewInvoicePage.qml")
            }
        },
        CAction {
            enabled: view.currentRow >= 0
            text: qsTr("Details")
            icon.name: "cil-notes"
            onTriggered: {
                Router.navigate(
                            "qrc:/PosFe/qml/pages/invoices/InvoiceDetailsPage.qml",
                            {
                                "keyValue": model.jsonObject(
                                                view.currentRow).id
                            })
            }
        },
        CAction {
            // Pay action only enabled for invoices that still owe money. Gated by
            // prm_pay_invoice — same backend permission the /invoice/pay route checks.
            enabled: view.currentRow >= 0 &&
                     AuthManager.hasPermission("prm_pay_invoice") &&
                     parseFloat(model.jsonObject(view.currentRow)?.balance_due ?? 0) > 0
            text: qsTr("Pay")
            icon.name: "cil-credit-card"
            onTriggered: {
                let row = model.jsonObject(view.currentRow)
                payDialog.invoiceId    = row.id
                payDialog.balanceDue   = parseFloat(row.balance_due)
                payDialog.customerName = row?.party?.name ?? ""
                payDialog.open()
            }
        }
    ]
}
