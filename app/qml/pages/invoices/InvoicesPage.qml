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
                            "qrc:/PosFe/qml/pages/Accounting/InvoiceDetailsPage.qml",
                            {
                                "keyValue": model.jsonObject(
                                                view.currentRow).id
                            })
            }
        }
    ]
}
