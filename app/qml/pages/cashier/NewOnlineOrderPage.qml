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
import JsonModels

AppPage {
    id: page
    padding: 0
    Component.onCompleted: {
        NetworkManager.get("/onlinesales/dashboard").subscribe(
                    function (response) {
                        paymentMethodCB.model = response.json(
                                    "payment_methods").data;
                        productsCB.model = response.json("products").data;
                        customerCB.model = response.json("customers").data;
                        driverCB.model = response.json("drivers")
                        page.barqLocations = response.json(
                                    "barq_locations").data
                        page.internalLocations = response.json(
                                    "combo_locations").data;


                        carrierCB.model=[{
                                             "id": 1,
                                             "name": qsTr("Internal"),
                                             "method": enableInternalDelivery
                                         }, {
                                             "id": 2,
                                             "name": qsTr("Barq"),
                                             "method": enableBarq
                                         }]

                    })
    }

    title: qsTr("Online Sales")
    //    palette.window: "transparent"
    background: Rectangle {
        color: "transparent"
    }
    LayoutMirroring.enabled: false
    property bool pay: false
    property int sessionId: -1
    property var barqLocations
    property var internalLocations

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
        let address = {}

        let addressId = addressCB.currentValue

        if (addressId === -1) {
            address["province"] = provinceCB.editText
            address["district"] = districtCB.editText
            address["phone"] = phoneLE.text
            address["name"] = addressNameLE.text
            address["first_name"] = customerCB.currentText
            address["details"] = addressDetailsLE.text
        } else {
            address["id"] = addressId
        }
        let deliveryInfo = {
            "carrier_id": carrierCB.currentValue,
            "address": address,
            "notes": deliveryNotesLE.text
        }

        if (carrierCB.currentValue === 1) {
            deliveryInfo["driver_id"] = driverCB.currentValue
        }

        // address[""]

        // if (deliverySwitch.checked) {
        //     //needs to be adjusted for internal delivery
        //     deliveryInfo["city_id"] = districtCB.model.data(
        //                 districtCB.currentIndex, "id")
        //     deliveryInfo["town_id"] = townCB.model.data(townCB.currentIndex,
        //                                                 "id")
        // }
        // cashierModel.processCart(cashierModel.total, 0, deliveryNotesLE.text,
        //                          deliveryInfo)
        let cartData = cashierModel.cartData()

        let customerInfo = {}
        if (customerCB.currentIndex < 0) {
            //update customers here
            customerInfo["name"] = customerCB.editText
        } else {
            customerInfo["id"] = customerCB.currentValue
        }

        let payload = {
            "cart": cashierModel.cartData(),
            "payment_method_id": paymentMethodCB.currentValue,
            "customer_info": customerInfo,
            "shipment_info": deliveryInfo
        }

        NetworkManager.post('/onlinesales/purchase',
                            payload).subscribe(function (response) {

                                if (response.json('status') === 200) {
                                    confirmDlg.close()
                                    receiptDialog.receiptData = response.json(
                                                'order')
                                    receiptDialog.open()
                                    cashierModel.requestCart()
                                }
                            })
    }

    // PayDialog {
    //     id: paymentDialog
    //     onAccepted: {
    //         if (customerCB.currentIndex < 0) {
    //             //update customer then process cart
    //             pay = true
    //             customersModel.addCustomer(customerCB.editText, "", "", "",
    //                                        phoneLE.text, addressLE.text)
    //         } else {
    //             page.processCart()
    //         }
    //     } //accepted
    // } //payDialog
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
            Layout.minimumHeight: window.height * 0.5
            Layout.minimumWidth: page.width * 0.7
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            //Layout.minimumWidth: 1000
            model: CashierModel {
                id: cashierModel
                // onUpdateCustomerResponseReceived: res => {
                //                                       if (res.status === 200) {
                //                                           if (pay) {
                //                                               page.processCart()
                //                                               pay = false
                //                                           }
                //                                       }
                //                                   } //onUpdateCustomerResponseReceived
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

        AppConfirmationDialog {
            id: confirmDlg
            title: qsTr("Confirm")
            message: qsTr("Do you want to place order?")

            onAccepted: page.processCart()
            onCanceled: close()
        }

        Card {
            //pay button card
            Layout.fillHeight: true
            Layout.fillWidth: true
            palette.base: "transparent"
            padding: 10
            GridLayout {
                anchors.fill: parent
                columns: 1

                function confirmPayment() {
                    confirmDlg.open()
                }

                CLabel {
                    text: qsTr("Product")
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
                        if (!dataReceived) {
                            dataReceived = true
                            return
                        }

                        if (currentValue !== undefined && count)
                            cashierModel.addProduct(currentValue)
                    }

                    model: JsonModel {}

                    // model: AppNetworkedJsonModel {
                    //     url: "/products/list"
                    //     filter: {
                    //         "only_variants": true
                    //     }
                    //     onDataRecevied: {
                    //         productsCB.dataReceived = true
                    //     }
                    // }
                }

                CLabel {
                    text: qsTr("Barcode")
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

                CLabel {
                    text: qsTr("Delivery Carrier")
                }

                CComboBox {
                    id: carrierCB
                    valueRole: "id"
                    textRole: "name"
                    Layout.fillWidth: true

                    Component.onCompleted: {
                        console.log("current index: " + currentIndex)
                        currentIndex = indexOfValue(
                                    Settings.get(
                                        "OnlineOrdersPage/CarrierCBValue", 1))
                        initialized = true // we need to initalize here on static models
                    }
                    onCurrentValueChanged: {
                        if (initialized) {
                            Settings.set("OnlineOrdersPage/CarrierCBValue",
                                         currentValue)
                        }
                    }

                    onCurrentIndexChanged: {
                        //Settings.externalDelivery = checked

                        //this is the catalyst
                        model[currentIndex].method();
                    }
                }

                CLabel {
                    text: qsTr("Driver")
                }

                CComboBox {
                    id: driverCB
                    enabled: carrierCB.currentIndex === 0
                    valueRole: "id"
                    textRole: "username"
                    Layout.fillWidth: true

                    onModelChanged: {
                        initialized = true
                        currentIndex = indexOfValue(
                                    Settings.get(
                                        "OnlineOrdersPage/DriverCBValue", 1))
                    }
                    onCurrentValueChanged: {
                        if (initialized) {
                            Settings.set("OnlineOrdersPage/DriverCBValue",
                                         currentValue)
                        }
                    }

                    //need a special model with id name values
                }

                CLabel {
                    text: qsTr("Payment Method")
                }

                CComboBox {
                    id: paymentMethodCB

                    valueRole: "id"
                    textRole: "name"
                    Layout.fillWidth: true

                    onModelChanged: {
                        initialized = true
                        currentIndex = indexOfValue(
                                    Settings.get(
                                        "OnlineOrdersPage/paymentMethodCBValue",
                                        2)) //2 is COD
                    }
                    onCurrentValueChanged: {
                        if (initialized) {
                            Settings.set("OnlineOrdersPage/paymentMethodCBValue",
                                         currentValue)
                        }
                    }
                }

                VerticalSpacer {}

                CLabel {
                    text: qsTr("Total")
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
                    text: qsTr("Place Order")
                    palette.button: "#2eb85c"
                    palette.buttonText: "#ffffff"
                    Layout.fillWidth: true
                    implicitHeight: 50
                    onClicked: parent.confirmPayment()

                    enabled: tableView.rows

                    // enabled: {
                    //     if (deliverySwitch.enabled) {
                    //         return provinceCB.valid && districtCB.valid && provinceCB.currentText && districtCB.currentText
                    //     } else {
                    //         return tableView.rows > 0
                    //     }
                    // }
                }
            }
        }

        Card {
            //customer info card
            Layout.fillHeight: true
            Layout.fillWidth: true
            padding: 5
            Layout.columnSpan: 2
            palette.base: "transparent"
            GridLayout {
                anchors.fill: parent
                flow: GridLayout.TopToBottom

                CLabel {
                    text: qsTr("Customer Name") + "<font color='red'> *</font>"
                    font.bold: true
                }
                columns: 5
                rows: 4
                IconComboBox {
                    property bool isValid: currentText === editText
                    id: customerCB
                    leftIcon.name: "cil-user"
                    Layout.alignment: Qt.AlignTop

                    Layout.fillWidth: true
                    Layout.minimumHeight: 50

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
                    onModelChanged: {
                        if (currentIndex >= 0) {
                            var currentCustomer = customerCB.model[currentIndex]
                            updateaddressCB(currentCustomer.addresses ?? [])
                        } else {
                            updateaddressCB([])
                        }
                    }

                    onCurrentIndexChanged: {
                        if (currentIndex >= 0) {
                            var currentCustomer = customerCB.model[currentIndex]
                            updateaddressCB(currentCustomer.addresses ?? [])
                        } else {
                            updateaddressCB([])
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

                CLabel {
                    text: qsTr("select Address")
                    font.bold: true
                }

                IconComboBox {
                    id: addressCB
                    property bool isNew: addressCB.model[currentIndex].id === -1
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("New Address...")
                    editable: false
                    leftIcon.name: "cil-address-book"
                    textRole: "name"
                    valueRole: "id"
                    model: [{
                            "id": -1,
                            "name": qsTr("Add New...")
                        }]

                    onCurrentIndexChanged: {
                        page.refreshCustomerForm()
                    }
                    onModelChanged: page.refreshCustomerForm()
                }

                MenuSeparator {
                    padding: 25
                    topPadding: 0
                    bottomPadding: 0
                    Layout.fillHeight: true
                    Layout.rowSpan: 4
                    Layout.margins: 0

                    contentItem: Rectangle {
                        implicitWidth: 1
                        color: page.palette.shadow
                    }
                }

                CLabel {
                    text: qsTr("Address Name") + "<font color='red'> *</font>"
                    font.bold: true
                }

                CIconTextField {
                    Layout.alignment: Qt.AlignTop
                    id: addressNameLE
                    //id: customerPhone
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("Home, work, etc...")
                    leftIcon.name: "cil-notes"
                    text: qsTr("Default")
                    readOnly: !addressCB.isNew
                }

                CLabel {
                    text: qsTr("Province") + "<font color='red'> *</font>"
                    font.bold: true
                }

                IconComboBox {
                    id: provinceCB

                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("Province...")
                    editable: true
                    leftIcon.name: "cil-map"
                    textRole: "name"
                    valueRole: "name"
                    onCurrentIndexChanged: {
                        if (provinceCB.currentIndex >= 0) {
                            districtCB.parentLocationId = provinceCB.model.data(
                                        provinceCB.currentIndex, "name") ?? null
                            districtCB.currentIndex = 0
                        }
                    }
                    model: JsonModel {}
                }

                CLabel {
                    text: qsTr("District") + "<font color='red'> *</font>"
                    font.bold: true
                }

                IconComboBox {
                    id: districtCB
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("District...")
                    textRole: "name"
                    valueRole: "name"
                    editable: true
                    leftIcon.name: "cil-city"
                    property var parentLocationId: null
                    onParentLocationIdChanged: refresh()

                    function refresh() {
                        if (parentLocationId === null
                                || parentLocationId === undefined) {
                            return
                        }

                        model.records = provinceCB.model.data(
                                    provinceCB.currentIndex, "children")
                    }

                    model: JsonModel {}
                }

                CLabel {
                    text: qsTr("Phone") + "<font color='red'> *</font>"
                    font.bold: true
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

                CLabel {
                    text: qsTr("Address Details")
                    font.bold: true
                }

                CIconTextField {
                    id: addressDetailsLE
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("Street, Nearest landmark, etc...")
                    leftIcon.name: "cil-location-pin"
                }

                CLabel {
                    text: qsTr("Delivery Notes")
                    font.bold: true
                }

                CIconTextField {
                    Layout.alignment: Qt.AlignTop
                    id: deliveryNotesLE
                    //id: customerPhone
                    Layout.fillWidth: true
                    implicitHeight: 50
                    placeholderText: qsTr("Delivery Note...")
                    leftIcon.name: "cil-notes"
                }
            }
        }
    } // GridLayout end

    // JsonModel {
    //     id: barqProvinceModel
    // }
    // JsonModel {
    //     id: barqCityModel
    //     property int parentLocationId: -1
    //     onParentLocationIdChanged: {
    //         records = barqProvinceModel.data(provinceCB.currentIndex,
    //                                          "children")
    //     }
    // }

    // AppNetworkedJsonModel {
    //     id: internalProvinceModel
    //     url: "locations/comboList"
    // }

    // AppNetworkedJsonModel {
    //     id: internalCityModel
    //     url: "locations/comboList"
    //     filter: {
    //         "province": provinceCB.editText
    //     }
    //     onFilterChanged: requestData();
    // }
    function updateaddressCB(customerAddresses) {
        let newModel = customerAddresses.concat([{
                                                     "id": -1,
                                                     "name": qsTr("Add New...")
                                                 }])
        addressCB.model = newModel
    }
    function enableBarq() {
        provinceCB.model.records = page.barqLocations
        provinceCB.currentIndex = 0
        districtCB.parentLocationId = provinceCB.model.data(
                    provinceCB.currentIndex, "name") ?? null
        districtCB.refresh()
    }
    function enableInternalDelivery() {
        provinceCB.model.records = page.internalLocations
        provinceCB.currentIndex = 0
        districtCB.parentLocationId = provinceCB.model.data(
                    provinceCB.currentIndex, "name") ?? null
        districtCB.refresh()
    }

    function refreshCustomerForm() {

        if (addressCB.currentIndex >= 0) {

            let item = addressCB.model[addressCB.currentIndex]
            if (item.id === -1) {
                // currentIndex=-2;
                addressNameLE.text
                        = "Default" //handle when there is another address with the name "Default"
                provinceCB.currentIndex = 0
                districtCB.currentIndex = 0
                phoneLE.clear()
                addressDetailsLE.clear()
                deliveryNotesLE.clear()
            } else {
                addressNameLE.text = item.name
                phoneLE.text = item.phone
                provinceCB.currentIndex = provinceCB.find(item.province)
                districtCB.currentIndex = districtCB.find(item.district)
                addressDetailsLE.text = item.details

                //sara al-khazraji
            }
        }
    }
}
