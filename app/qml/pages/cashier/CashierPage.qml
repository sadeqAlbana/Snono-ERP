import QtQuick
import QtQuick.Layouts

import QtQuick.Controls.Basic
import Qt.labs.qmlmodels 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Impl
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage {
    id: page
    padding: 0
    title: qsTr("Cashier")
    //    palette.window: "transparent"
    background: Rectangle {
        color: "transparent"
    }
    LayoutMirroring.enabled: false
    property bool pay: false
    property int sessionId: -1

    CashierReceiptDialog {
        id: receiptDialog
    } //receiptDialog

    Keys.enabled: true

    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete
                            && tableView.currentRow >= 0) {
                            cashierModel.removeProduct(tableView.currentRow)
                        }
                    }


    // payment_method_id = -1 is the cashier sentinel for "on credit" — backend leaves the
    // invoice unpaid and customer AR carries the balance. See ../../../pos-be-base/app/http/
    // controllers/poscontroller.cpp purchaseProducts handler.
    readonly property int creditMethodId: -1

    Component.onCompleted: {
        NetworkManager.get("/pos/dashboard").subscribe(
                    function (response) {
                        var methods = response.json("payment_methods").data;
                        if (AuthManager.hasPermission("prm_pos_sell_on_credit")) {
                            methods = methods.concat([{ id: page.creditMethodId,
                                                        name: qsTr("On Credit") }]);
                        }
                        paymentMethodCB.model = methods;
                        customerCB.model = response.json("customers").data;
                    });

        barcodeInput.forceActiveFocus();

    }


    function processCart() {

        let paymentMethodId=paymentMethodCB.currentValue
        let isCredit = (paymentMethodId === page.creditMethodId)
        // Backend forces paid/returned to 0 for credit, but we send 0 explicitly so the
        // FE-visible state and the persisted order row agree.
        let paid = isCredit ? 0 : cashierModel.total
        cashierModel.processCart(paid, 0, paymentMethodId, notesLE.text)
    }

    PayDialog {
        id: paymentDialog
        onAccepted: {
            if (customerCB.currentIndex < 0 && customerCB.editText.length > 0) {
                Api.addCustomer({
                    "name": customerCB.editText,
                    "phone": phoneLE.text,
                    "address_line": addressLE.text
                }).subscribe(function(res){
                    var reply = res.json()
                    if (reply.status !== 200) {
                        toastrService.push(qsTr("Error"),
                                           reply.message ?? qsTr("Failed to create customer"),
                                           "danger", 4000)
                        return
                    }
                    pay = true
                    tableView.model.updateCustomer(reply.customer.id)
                })
            } else {
                page.processCart()
            }
        } //accepted
    } //payDialog

    ProductPickerDialog {
        id: productPickerDialog
        onProductPicked: productId => cashierModel.addProduct(productId)
    }

    CreditConfirmDialog {
        id: creditConfirmDialog
        onAccepted: page.processCart()
    }

    GridLayout {
        //main   grid
        anchors.fill: parent
        rows: window.moibleLayout ? 4 : 2
        columns: window.moibleLayout ? 1 : 2
        flow: GridLayout.TopToBottom
        CTableView {
            id: tableView
            Layout.row: 0
            Layout.column: 0
            Layout.rowSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true

            selectionBehavior: TableView.SelectCells

            delegate: AppDelegateChooser {}
            implicitHeight: 300
            Layout.minimumHeight: 300
            Layout.minimumWidth: 300

            Layout.alignment: Qt.AlignCenter
            //Layout.minimumWidth: 1000
            actions:[
                CAction {
                    text: qsTr("Delete")
                    icon.name: "cil-delete"
                    enabled: tableView.currentRow >= 0
                    onTriggered: cashierModel.removeProduct(tableView.currentRow)
                }
            ]
            model: CashierModel {
                id: cashierModel
                onPurchaseResponseReceived: res => {
                                                if (res.status === 200) {
                                                    paymentDialog.close()
                                                    receiptDialog.receiptData = res.order
                                                    receiptDialog.open()
                                                    // if (customerCB.currentIndex < 0) {
                                                    //     customersModel.refresh()
                                                    // }
                                                    notesLE.text = ""
                                                    requestCart()
                                                }
                                            }
                onUpdateCustomerResponseReceived: res => {
                                                      if (res.status === 200) {
                                                          if (pay) {
                                                              pay = false
                                                              page.processCart()
                                                          }
                                                      }
                                                  } //onUpdateCustomerResponseReceived
                onAddProductReply: res => {
                                       if (res.status === 200) {
                                           scannerBeep.play()
                                           productsCB.currentIndex = -1
                                       } /*else{
                                                                                                      toastrService.push("Warning",res.message,"warning",2000)
                                                                                                                                                                                         }*/
                                   } //onAddProductReply
            }
        } //tableView

        ColumnLayout { //layout 1
            Layout.alignment: Qt.AlignCenter
            Layout.row: window.mobileLayout? 2 : 0
            Layout.column: window.mobileLayout? 0 : 1
            Numpad {
                id: numpad
                visible: !window.mobileLayout
                enabled: tableView.currentRow >= 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter

                onButtonClicked: button => {
                                     if (button.key===Qt.Key_Backspace && tableView.currentRow >= 0) {
                                         cashierModel.removeProduct(
                                             tableView.currentRow)
                                     }
                                 }
            }
            CComboBox {
                Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width

                id: productsCB
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                property bool dataReceived: false

                function addProduct(){
                    if (currentValue !== undefined && dataReceived){
                        cashierModel.addProduct(currentValue)
                    }
                }
                onActivated: addProduct();
                onAccepted: addProduct();
                model: AppNetworkedJsonModel {
                    url: "/products/list"
                    filter: {
                        "only_variants": true
                    }
                    onDataRecevied: {
                        productsCB.dataReceived = true
                    }
                }
            }

            CButton {
                text: qsTr("Browse Products")
                icon.name: "cil-image"
                palette.button: "#3399ff"
                palette.buttonText: "#ffffff"
                Layout.fillWidth: true
                Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width
                implicitHeight: 40
                onClicked: productPickerDialog.open()
            }

            CTextField {
                id: barcodeInput
                Layout.fillWidth: true
                Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width

                onAccepted: {
                    cashierModel.addProduct(text, true)
                    text = ""
                }
                placeholderText: qsTr("Barcode...")
                implicitHeight: 50
            }

            CComboBox {
                id: paymentMethodCB

                valueRole: "id"
                textRole: "name"
                Layout.fillWidth: true
                Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width
                onModelChanged: {
                    initialized = true
                    currentIndex = indexOfValue(
                                Settings.get(
                                    "CashierPage/paymentMethodCBValue",
                                    2)) //2 is COD
                }
                onCurrentValueChanged: {
                    if (initialized) {
                        Settings.set("CashierPage/paymentMethodCBValue",
                                     currentValue)
                    }
                }
            }

        }



        ColumnLayout { //Layout2
            Layout.row: window.mobileLayout? 3 : 1
            Layout.column: window.mobileLayout? 0 : 1

            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width

            IconComboBox {
                property bool isValid: currentText === editText
                id: customerCB
                visible: true
                enabled:true
                Layout.fillWidth: true
                implicitHeight: 50
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-user"

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        var currentCustomer = customerCB.model[customerCB.currentIndex];
                        phoneLE.text = currentCustomer.phone ?? ""
                        addressLE.text = currentCustomer.address_line ?? ""
                        tableView.model.updateCustomer(currentCustomer.id)
                    } else {
                        phoneLE.text = ""
                        addressLE.text = ""
                    }
                } //onCurrentIndexChanged

                onActiveFocusChanged: {
                    var edit = editText
                    if (!activeFocus && editText != currentText) {
                        currentIndex = -1
                    }
                    editText = edit
                } //onActiveFocusChanged
            }

            CIconTextField {
                id: phoneLE
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                implicitHeight: 50
                placeholderText: qsTr("Phone...")
                leftIcon.name: "cil-phone"
            }

            CIconTextField {
                id: addressLE
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                implicitHeight: 50
                placeholderText: qsTr("Address...")
                leftIcon.name: "cil-location-pin"
            }

            CIconTextField {
                Layout.alignment: Qt.AlignTop
                id: notesLE
                //id: customerPhone
                Layout.fillWidth: true
                implicitHeight: 50
                placeholderText: qsTr("Note...")
                leftIcon.name: "cil-notes"
            }

            //total and pay layout


            CTextField {
                id: total
                readOnly: true
                text: Utils.formatNumber(cashierModel.total) + " IQD"
                Layout.fillWidth: true
                font.pixelSize: 20
                implicitHeight: 50
            }
            CButton {
                text: qsTr("Pay")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                Layout.fillWidth: true
                implicitHeight: 50
                onClicked: parent.confirmPayment()
                enabled: tableView.rows > 0


            }



            function confirmPayment() {
                let isCredit = (paymentMethodCB.currentValue === page.creditMethodId)
                if (isCredit) {
                    // Walk-in guard mirrors the backend's status=-6 reject — surfaced as a
                    // toastr instead of round-tripping a server error. party_id=1 is the
                    // seeded walk-in default; credit needs a real named customer so AR
                    // attaches to someone.
                    let customerId = customerCB.currentIndex >= 0
                        ? (customerCB.model[customerCB.currentIndex]?.id ?? 0)
                        : 0
                    if (customerId <= 1) {
                        toastrService.push(qsTr("Error"),
                                           qsTr("Pick a customer before selling on credit."),
                                           "error", 4000)
                        return
                    }
                    // No cash counting needed — show a lightweight confirm step so the
                    // operator gets a visible "you're booking this on credit" prompt
                    // (PayDialog serves that role for cash; credit gets its own dialog).
                    creditConfirmDialog.amount = cashierModel.total
                    creditConfirmDialog.customerName = customerCB.model[customerCB.currentIndex]?.name ?? ""
                    creditConfirmDialog.open()
                    return
                }
                paymentDialog.amount = cashierModel.total
                paymentDialog.paid = cashierModel.total
                paymentDialog.open()
            }
        } //ColumnLayout
    } // GridLayout end
}
