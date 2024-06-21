import QtQuick
import QtQuick.Layouts

import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
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
                        if (event.key === Qt.Key_Backspace
                            && tableView.currentRow >= 0) {
                            cashierModel.removeProduct(tableView.currentRow)
                        }
                    }

    function processCart() {
        cashierModel.processCart(cashierModel.total, 0, notesLE.text)
    }

    PayDialog {
        id: paymentDialog
        onAccepted: {
            if (customerCB.currentIndex < 0) {
                //update customer then process cart
                pay = true
                customersModel.addCustomer(customerCB.editText, "", "", "",
                                           phoneLE.text, addressLE.text)
            } else {
                page.processCart()
            }
        } //accepted
    } //payDialog

    GridLayout {
        //main   grid
        anchors.fill: parent
        rows: window.moibleLayout ? 1 : 2
        columns: window.moibleLayout ? 4 : 2
        flow: GridLayout.LeftToRight
        CTableView {
            id: tableView
            Layout.row: 0
            Layout.column: 0
            Layout.fillHeight: true
            selectionBehavior: TableView.SelectCells

            delegate: AppDelegateChooser {}
            Layout.fillWidth: true
            implicitHeight: 300
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            //Layout.minimumWidth: 1000
            model: CashierModel {
                id: cashierModel
                onPurchaseResponseReceived: res => {
                                                if (res.status === 200) {
                                                    paymentDialog.close()
                                                    receiptDialog.receiptData = res.order
                                                    receiptDialog.open()
                                                    if (customerCB.currentIndex < 0) {
                                                        customersModel.refresh()
                                                    }
                                                    notesLE.text = ""
                                                    requestCart()
                                                }
                                            }
                onUpdateCustomerResponseReceived: res => {
                                                      if (res.status === 200) {
                                                          if (pay) {
                                                              page.processCart()
                                                              pay = false
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

        ColumnLayout {
            Layout.column: window.mobileLayout ? 0 : 1
            Layout.row: window.mobileLayout ? 1 : 0
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

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
                    if (currentValue !== undefined && dataReceived)
                        cashierModel.addProduct(currentValue)
                }

                onCurrentValueChanged: addProduct()

                onActivated: addProduct();
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

            CTextField {
                id: numpadInput
                Layout.fillWidth: true
                Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width

                onAccepted: {
                    cashierModel.addProduct(text, true)
                    text = ""
                }
                placeholderText: qsTr("Barcode...")
                implicitHeight: 50
            }
        }

        GridLayout {
            //customer grid
            Layout.alignment: Qt.AlignCenter
            Layout.row: window.mobileLayout ? 2 : 1
            columnSpacing: 15
            Layout.column: 0
            columns: window.mobileLayout ? 1 : 2
            IconComboBox {
                property bool isValid: currentText === editText
                id: customerCB
                Layout.fillWidth: true
                implicitHeight: 50
                model: CustomersModel {
                    id: customersModel
                    usePagination: false
                    onAddCustomerReply: reply => {
                                            if (reply.status === 200) {
                                                cashierModel.updateCustomer(
                                                    reply.customer.id)
                                            }
                                        }
                    Component.onCompleted: {
                        usePagination = false
                    }
                }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-user"

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        var currentCustomer = customersModel.jsonObject(
                                    customerCB.currentIndex)
                        phoneLE.text = customersModel.jsonObject(
                                    customerCB.currentIndex).phone
                        addressLE.text = customersModel.jsonObject(
                                    customerCB.currentIndex).address
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
                enabled: !customerCB.isValid
                validator: RegularExpressionValidator {
                    regularExpression: /^(?:\d{2}-\d{3}-\d{3}-\d{3}|\d{11})$/
                }

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                implicitHeight: 50
                placeholderText: qsTr("Phone...")
                leftIcon.name: "cil-phone"
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
        }

        ColumnLayout {
            //total and pay layout
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width
            Layout.row: window.mobileLayout ? 3 : 1
            Layout.column: window.mobileLayout ? 0 : 1

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
                paymentDialog.amount = cashierModel.total
                paymentDialog.paid = cashierModel.total
                paymentDialog.open()
            }
        } //ColumnLayout
    } // GridLayout end
}
