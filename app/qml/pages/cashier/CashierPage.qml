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


    Component.onCompleted: {
        NetworkManager.get("/pos/dashboard").subscribe(
                    function (response) {
                        // paymentMethodCB.model = response.json(
                        //             "payment_methods").data;
                        customerCB.model = response.json("customers").data;
                    })
    }


    function processCart() {
        cashierModel.processCart(cashierModel.total, 0, notesLE.text)
    }

    PayDialog {
        id: paymentDialog
        onAccepted: {
            page.processCart();
            pay=true;
        } //accepted
    } //payDialog

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



        ColumnLayout { //Layout2
            Layout.row: window.mobileLayout? 3 : 1
            Layout.column: window.mobileLayout? 0 : 1

            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: window.mobileLayout ? -1 : numpad.width

            IconComboBox {
                property bool isValid: currentText === editText
                id: customerCB
                visible: false
                enabled:false
                Layout.fillWidth: true
                implicitHeight: 50
                // model: CustomersModel {
                //     id: customersModel
                //     usePagination: false
                //     onAddCustomerReply: reply => {
                //                             if (reply.status === 200) {
                //                                 cashierModel.updateCustomer(
                //                                     reply.customer.id)
                //                             }
                //                         }
                //     Component.onCompleted: {
                //         usePagination = false
                //     }
                // }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-user"

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        var currentCustomer = customerCB.model[customerCB.currentIndex];
                        phoneLE.text = currentCustomer.phone
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
                visible:false
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
                paymentDialog.amount = cashierModel.total
                paymentDialog.paid = cashierModel.total
                paymentDialog.open()
            }
        } //ColumnLayout
    } // GridLayout end
}
