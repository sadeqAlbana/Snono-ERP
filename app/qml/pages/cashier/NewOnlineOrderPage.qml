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
import CoreUI

AppPage {
    id: page
    padding:0
    title: qsTr("Cashier")
    //    palette.window: "transparent"
    background: Rectangle {
        color: "transparent"
    }
    LayoutMirroring.enabled: false
    property bool pay: false
    property int sessionId: -1

    ReceiptDialog {
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
        let deliveryInfo = {}
        if (deliverySwitch.checked) {
            deliveryInfo["city_id"] = cityCB.model.data(cityCB.currentIndex, "id")
            deliveryInfo["town_id"] = townCB.model.data(townCB.currentIndex, "id")
        }

        cashierModel.processCart(cashierModel.total, 0, notesLE.text,
                                 deliveryInfo)
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
            Layout.minimumHeight: window.height*0.5
            Layout.minimumWidth: page.width*0.7
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

            Card{ //pay button card
                Layout.fillHeight: true
                Layout.fillWidth: true
                palette.base: "transparent"
                padding: 10
                GridLayout{
                    anchors.fill: parent;
                    columns: 1





                    function confirmPayment() {
                        paymentDialog.amount = cashierModel.total
                        paymentDialog.paid = cashierModel.total
                        paymentDialog.open()
                    }

                    CComboBox {

                        id: productsCB
                        Layout.fillWidth: true
                        textRole: "name"
                        valueRole: "id"
                        currentIndex: 0
                        editable: true
                        property bool dataReceived: false
                        onCurrentValueChanged: {
                            if (currentValue !== undefined && dataReceived)
                                cashierModel.addProduct(currentValue)
                        }

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


                        onAccepted: {
                            cashierModel.addProduct(text, true)
                            text = ""
                        }
                        placeholderText: qsTr("Barcode...")
                        implicitHeight: 50
                    }

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
                        // enabled: {
                        //     if (deliverySwitch.enabled) {
                        //         return provTF.valid && districtTF.valid && provTF.currentText && districtTF.currentText
                        //     } else {
                        //         return tableView.rows > 0
                        //     }
                        // }
                    }



                    CComboBox{
                        id: deliveryCB;
                        valueRole: "code"
                        textRole: "name"
                        Layout.fillWidth: true

                        model:[
                            {"code": 0, "name": qsTr("Internal"), "method": enableInternalDelivery},
                            {"code": 1, "name": qsTr("Barq"), "method": enableBarq}
                        ]


                        onCurrentIndexChanged: {
                            //Settings.externalDelivery = checked

                            model[currentIndex].method()

                        }

                        function enableInternalDelivery(){

                        }
                    }

                    CComboBox{
                        visible: deliveryCB.currentIndex===0
                        valueRole: "id"
                        textRole: "name"
                        Layout.fillWidth: true
                        //need a special model with id name values
                        model: AppNetworkedJsonModel{
                            url:"driver/list"
                            Component.onCompleted: requestData();

                        }

                    }

                    VerticalSpacer{}


                }
            }


            Card{ //customer info card
                Layout.fillHeight: true
                Layout.fillWidth: true
                padding: 5
                Layout.columnSpan: 2
                palette.base: "transparent"
                GridLayout{
                    anchors.fill: parent

                    columns: 3
                        IconComboBox {


                            property bool isValid: currentText === editText
                            id: customerCB
                            leftIcon.name: "cil-user"
                            Layout.alignment: Qt.AlignTop

                            Layout.fillWidth: true
                            Layout.minimumHeight: 50

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

                            onCurrentIndexChanged: {
                                if (currentIndex >= 0) {
                                    var currentCustomer = customersModel.jsonObject(
                                                customerCB.currentIndex)
                                    phoneLE.text = customersModel.jsonObject(
                                                customerCB.currentIndex).phone
                                    // addressLE.text = customersModel.jsonObject(
                                    //             customerCB.currentIndex).address
                                    tableView.model.updateCustomer(currentCustomer.id)
                                } else {
                                    //phoneLE.text = ""
                                    //addressLE.text = ""
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
                            validator: RegularExpressionValidator {
                                regularExpression: /^(?:\d{2}-\d{3}-\d{3}-\d{3}|\d{11})$/
                            }

                            Layout.alignment: Qt.AlignTop
                            Layout.fillWidth: true
                            Layout.minimumHeight: 50
                            placeholderText: qsTr("Phone...")
                            leftIcon.name: "cil-phone"
                        }


                        IconComboBox {
                            id: provTF

                            Layout.alignment: Qt.AlignTop
                            Layout.fillWidth: true
                            implicitHeight: 50
                            placeholderText: qsTr("Province...")
                            editable: true
                            leftIcon.name: "cil-location-pin"
                        }


                        // CIconTextField {
                        //     id: addressLE
                        //     enabled: !customerCB.isValid
                        //     Layout.alignment: Qt.AlignTop
                        //     Layout.fillWidth: true
                        //     implicitHeight: 50
                        //     placeholderText: qsTr("Address Details...")
                        //     leftIcon.name: "cil-location-pin"
                        // }



                    CIconTextField {
                        Layout.alignment: Qt.AlignTop
                        id: notesLE
                        //id: customerPhone
                        Layout.fillWidth: true
                        implicitHeight: 50
                        placeholderText: qsTr("Note...")
                        leftIcon.name: "cil-notes"
                    }



                    IconComboBox {
                        id: districtTF
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        implicitHeight: 50
                        placeholderText: qsTr("District...")
                        editable: true
                        leftIcon.name: "cil-location-pin"
                    }

                }
            }





    } // GridLayout end

    BarqLocationsModel {
        id: barqCityModel
        filter: {"parentId" : 0}
    }
    BarqLocationsModel {
        id: barqTownModel
        property int parentLocationId: 1;
        // filter: deliverySwitch.enabled? {"parentId" : parentLocationId} : ({})
        filter: {"parentId" : parentLocationId}
        onParentLocationIdChanged: {
            filter={"parentId":parentLocationId}
            requestData();
        }
    }


    function enableBarq(){
        provTF.valueRole= "id"
        provTF.textRole="name"
        districtTF.valueRole= "id"
        districtTF.textRole="name"
        provTF.model=barqCityModel
        districtTF.model=barqTownModel
        provTF.currentIndexChanged.connect(function(){
            if (provTF.currentIndex >= 0) {
                barqTownModel.parentLocationId = provTF.model.data(provTF.currentIndex, "id")
                districtTF.currentIndex = 0
            }
        });
    }
}
