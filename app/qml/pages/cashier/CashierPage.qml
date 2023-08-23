import QtQuick;
import QtQuick.Layouts

import QtQuick.Controls.Basic;
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


AppPage{
    id: page
    title: qsTr("Cashier")
    //    palette.window: "transparent"
    background: Rectangle{color: "transparent"}
    LayoutMirroring.enabled: false
    property bool pay: false
    property int sessionId : -1


    ReceiptDialog{
        id: receiptDialog
    }//receiptDialog


    function processCart(){
        let deliveryInfo={}
        if(deliverySwitch.checked){
            deliveryInfo["city_id"]=cityModel.data(cityCB.currentIndex,"id")
            deliveryInfo["town_id"]=townModel.data(townCB.currentIndex,"id")
        }

        cashierModel.processCart(cashierModel.total,0,notesLE.text,deliveryInfo);

    }

    PayDialog{
        id: paymentDialog
        onAccepted: {
            if(customerCB.currentIndex<0){
                //update customer then process cart
                pay=true
                customersModel.addCustomer(customerCB.editText,"","","",phoneLE.text,addressLE.text)
            }else{
                page.processCart();
            }
        }//accepted
    }//payDialog

    GridLayout{ //main   grid
        anchors.fill: parent;
        rows: window.moibleLayout? 1 : 2
        columns: window.moibleLayout? 4 : 2
        flow: GridLayout.LeftToRight
        CTableView{
            id: tableView
            Layout.row: 0
            Layout.column: 0
            Layout.fillHeight: true
            selectionBehavior: TableView.SelectCells

            delegate: AppDelegateChooser{}
            Layout.fillWidth: true
            implicitHeight: 300
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            //Layout.minimumWidth: 1000
            model: CashierModel{
                id: cashierModel
                onPurchaseResponseReceived: (res)=> {
                                                if(res.status===200){
                                                    paymentDialog.close();
                                                    receiptDialog.receiptData=res.order
                                                    receiptDialog.open();
                                                    if(customerCB.currentIndex<0){
                                                        customersModel.refresh();
                                                    }
                                                    notesLE.text=""
                                                    requestCart();
                                                }
                                            }
                onUpdateCustomerResponseReceived:(res)=> {
                                                     if(res.status===200){
                                                         if(pay){
                                                             page.processCart();
                                                             pay=false
                                                         }
                                                     }
                                                 }//onUpdateCustomerResponseReceived
                onAddProductReply:(res)=> {
                                      if(res.status===200){
                                          scannerBeep.play()
                                          productsCB.currentIndex=-1;

                                      }/*else{
                        toastrService.push("Warning",res.message,"warning",2000)
                    }*/
                                  }//onAddProductReply
            }

        }//tableView

        ColumnLayout{
            Layout.column: window.mobileLayout? 0: 1
            Layout.row: window.mobileLayout? 1 :0
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            Numpad{
                id: numpad
                visible: !window.mobileLayout
                enabled: tableView.currentRow>=0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter

                function clearClicked(){
                    cashierModel.removeProduct(tableView.currentRow);
                }
            }
            CComboBox{
                Layout.maximumWidth: window.mobileLayout? -1 :  numpad.width

                id: productsCB
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                property bool dataReceived: false
                onCurrentValueChanged:{
                    if(currentValue!==undefined && dataReceived)
                        cashierModel.addProduct(currentValue);
                }

                model: AppNetworkedJsonModel{
                    url: "/products/list"
                    filter: {"only_variants":true}
                    onDataRecevied: {
                        productsCB.dataReceived=true;
                    }
                }
            }

            CTextField{
                id: numpadInput
                Layout.fillWidth: true
                Layout.maximumWidth: window.mobileLayout? -1 :  numpad.width

                onAccepted:{
                    cashierModel.addProduct(text,true);
                    text=""
                }
                placeholderText: qsTr("Barcode...")
                implicitHeight: 50


            }
        }


        GridLayout{ //customer grid
            Layout.alignment: Qt.AlignCenter
            Layout.row: window.mobileLayout? 2 : 1
            columnSpacing: 15
            Layout.column: 0
            columns: window.mobileLayout? 1 : 2
            IconComboBox{
                property bool isValid: currentText===editText
                id: customerCB;
                Layout.fillWidth: true;
                implicitHeight: 50
                model: CustomersModel{
                    id: customersModel
                    usePagination: false
                    onAddCustomerReply:(reply)=> {
                        if(reply.status===200){
                            cashierModel.updateCustomer(reply.customer.id)
                        }
                    }
                    Component.onCompleted: {
                        usePagination=false;

                    }
                }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-user"

                onCurrentIndexChanged: {
                    if(currentIndex>=0){
                        var currentCustomer=customersModel.jsonObject(customerCB.currentIndex);
                        phoneLE.text=customersModel.jsonObject(customerCB.currentIndex).phone
                        addressLE.text=customersModel.jsonObject(customerCB.currentIndex).address
                        tableView.model.updateCustomer(currentCustomer.id);
                    }else{
                        phoneLE.text=""
                        addressLE.text=""
                    }
                }//onCurrentIndexChanged

                onActiveFocusChanged: {
                    var edit=editText
                    if(!activeFocus && editText!=currentText){
                        currentIndex=-1;
                    }
                    editText=edit;
                }//onActiveFocusChanged
            }
            CIconTextField{
                id: phoneLE
                enabled: !customerCB.isValid
                validator: RegularExpressionValidator{
                    regularExpression: /^(?:\d{2}-\d{3}-\d{3}-\d{3}|\d{11})$/
                }

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true;
                implicitHeight: 50
                placeholderText: qsTr("Phone...")
                leftIcon.name: "cil-phone"
            }
            CIconTextField{
                id: addressLE
                enabled: !customerCB.isValid
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true;
                implicitHeight: 50
                placeholderText: qsTr("Address...")
                leftIcon.name: "cil-location-pin"
            }
            CIconTextField{
                Layout.alignment: Qt.AlignTop
                id: notesLE
                //id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 50
                placeholderText: qsTr("Note...")
                leftIcon.name: "cil-notes"

            }
            IconComboBox{
                id: cityCB
                enabled: deliverySwitch.checked

                property bool isValid: currentText===editText
                Layout.fillWidth: true;
                implicitHeight: 50
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-location-pin"

                model: BarqLocationsModel{
                    id: cityModel
                    //                    onDataRecevied: {
                    //                        townModel.requestData();
                    //                    }
                }
                onCurrentIndexChanged: {
                    if(currentIndex>=0){
                        townModel.filter={"parentId": cityModel.data(currentIndex,"id")};
                        townCB.currentIndex=0;
                    }else{

                    }
                }
            }

            IconComboBox{
                id: townCB
                enabled: deliverySwitch.checked
                property bool isValid: currentText===editText
                Layout.fillWidth: true;
                implicitHeight: 50
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon.name: "cil-location-pin"



//                onCurrentIndexChanged:{
//                    var city=cityModel.data(cityCB.currentIndex,"name");
//                    var town=townModel.data(townCB.currentIndex,"name");
//                    addressLE.text=city + " - " + town

//                }

                model: BarqLocationsModel{
                    id: townModel
                    filter: {"parentId": 1}
                    onFilterChanged: requestData();
                }
            }
        }


        ColumnLayout{ //total and pay layout
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: window.mobileLayout? -1 :  numpad.width
            Layout.row: window.mobileLayout? 3: 1
            Layout.column: window.mobileLayout? 0 : 1



            CTextField{
                id: total
                readOnly: true
                text: Utils.formatNumber(cashierModel.total) + " IQD";
                Layout.fillWidth: true
                font.pixelSize: 20
                implicitHeight: 50

            }
            CButton{
                text: qsTr("Pay")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                Layout.fillWidth: true
                implicitHeight: 50
                onClicked: parent.confirmPayment();
                enabled: {
                    if(deliverySwitch.enabled){
                        return cityCB.isValid && townCB.isValid
                    }else{
                        return tableView.rows>0
                    }
                }
            }

            SwitchDelegate{
                id: deliverySwitch
                checked: Settings.externalDelivery
                text: qsTr("Barq Delivery")
                icon.source: "qrc:/images/icons/barq_logo.png"
                icon.color: "transparent"
                icon.height: 50
                Layout.fillWidth: true
                onCheckedChanged: {
                    Settings.externalDelivery=checked
                }
            }



            function confirmPayment(){
                paymentDialog.amount=cashierModel.total;
                paymentDialog.paid=cashierModel.total;
                paymentDialog.open();
            }
        }//ColumnLayout
    } // GridLayout end
}



