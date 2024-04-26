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
            //needs to be adjusted for internal delivery
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
                        //         return provinceCB.valid && cityCB.valid && provinceCB.currentText && cityCB.currentText
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



                    }

                    CComboBox{
                        id: driverCB
                        enabled: deliveryCB.currentIndex===0
                        valueRole: "id"
                        textRole: "name"
                        Layout.fillWidth: true
                        //need a special model with id name values
                        model: AppNetworkedJsonModel{
                            url:"driver/list"
                            Component.onCompleted: requestData();
                            onModelReset: {
                                driverCB.currentIndex=0;
                            }

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
                            id: provinceCB

                            Layout.alignment: Qt.AlignTop
                            Layout.fillWidth: true
                            implicitHeight: 50
                            placeholderText: qsTr("Province...")
                            editable: true
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


                    CIconTextField {
                        id: addressDetailsLE
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        implicitHeight: 50
                        placeholderText: qsTr("Address Details...")
                        leftIcon.name: "cil-location-pin"
                    }


                    IconComboBox {
                        id: cityCB
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
        id: barqProvinceModel
        filter: {"parentId" : 0}
    }
    BarqLocationsModel {
        id: barqCityModel
        property int parentLocationId: 1;
        // filter: deliverySwitch.enabled? {"parentId" : parentLocationId} : ({})
        filter: {"parentId" : parentLocationId}
        onParentLocationIdChanged: {
            filter={"parentId":parentLocationId}
            requestData();
        }
    }

    LocationsModel{
        id: internalProvinceModel;
    }

    LocationsModel{
        id: internalCityModel;
        filter: {"province": provinceCB.editText}
    }



    function enableBarq(){
        provinceCB.valueRole= "id"
        provinceCB.textRole="name"
        cityCB.valueRole= "id"
        cityCB.textRole="name"
        provinceCB.model=barqProvinceModel
        cityCB.model=barqCityModel
        provinceCB.currentIndexChanged.connect(function(){
            if (provinceCB.currentIndex >= 0) {
                barqCityModel.parentLocationId = provinceCB.model.data(provinceCB.currentIndex, "id")
                cityCB.currentIndex = 0
            }
        });
    }
    function enableInternalDelivery(){

        provinceCB.textRole="province"
        provinceCB.valueRole="province"
        provinceCB.model=internalProvinceModel

        cityCB.valueRole= "city"
        cityCB.textRole="city"
        cityCB.model=internalCityModel

        provinceCB.currentIndexChanged.connect(function(){
            console.log("edit text changed")
                barqCityModel.requestData();
                cityCB.currentIndex = 0

        });

    }
}
