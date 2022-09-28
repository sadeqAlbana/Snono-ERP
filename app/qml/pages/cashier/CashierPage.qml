import QtQuick;
import QtQuick.Controls.Basic;

import QtQuick.Layouts
import QtQuick.Controls

import Qt5Compat.GraphicalEffects

import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Impl
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import App.Models 1.0

AppPage{
    id: page
    title: qsTr("Cashier")
    //    palette.window: "transparent"
    background: Rectangle{color: "transparent"}
    LayoutMirroring.enabled: false
    padding: 10
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
        rows: 2
        columns: 2
        flow: GridLayout.LeftToRight
        CTableView{
            id: tableView
            Layout.row: 0
            Layout.column: 0
            Layout.fillHeight: true
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
            Layout.column: 1
            Layout.row: 0
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            Numpad{
                id: numpad
                enabled: tableView.selectedRow>=0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                  property bool waitingForDecimal: false
                property var decimalBtn;

                Component.onCompleted: {
                    decimalBtn=numpad.button(".");
                    decimalBtn.enabled=Qt.binding(function(){return !waitingForDecimal})
                    decimalBtn.clicked.connect(function(){waitingForDecimal=true})
                }

                onButtonClicked:(button)=> {
                    switch(button.type){
                    case "DIGIT": digitClicked(parseInt(button.text)); break;
                    case "COMMAND": commandClicked(button.text); break;
                    case "SPECIAL":  numpad.activeButton=button ;break;
                    default: break;
                    }
                }
                function digitClicked(digit){
                    var row=tableView.selectedRow;

                    var modelValue=null;
                    var key;
                    switch(numpad.activeButton.text){
                    case qsTr("Qty"): key="qty"; break;
                    case qsTr("Price"): key="unit_price"; break;
                    case qsTr("Disc"): key="discount"; break;

                    default: break;
                    }
                    modelValue=cashierModel.data(tableView.selectedRow,cashierModel.indexOf(key));

                    var newValue=NumberEditor.appendDigit(parseFloat(modelValue),digit,waitingForDecimal);
                    cashierModel.setData(row,key,newValue);
                    //                        waitingForDecimal=false
                }
                function commandClicked(command){

                    switch (command){
                    case "<" : backSpaceClicked(command); break;
                    case "C" : numpadInput.text="0"; break;
                    default: break;
                    }
                }

                function backSpaceClicked(command){
                    var row=tableView.selectedRow;
                    var key;
                    switch(activeButton.text){
                    case qsTr("Qty"): key="qty"; break;
                    case qsTr("Price"): key="unit_price"; break;
                    case qsTr("Disc"): key="discount"; break;

                    default: break;
                    }
                    var modelValue=cashierModel.data(tableView.selectedRow,cashierModel.indexOf(key));
                    if(modelValue===0 && activeButton.text===qsTr("Qty")){
                        clearClicked();
                    }else{
                        var newValue=NumberEditor.removeDigit(modelValue);
                        cashierModel.setData(row,key,newValue);

                    }
                }
                function clearClicked(){
                    cashierModel.removeProduct(tableView.selectedRow);
                }
            }
            CComboBox{
                Layout.maximumWidth: numpad.width

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

                model: NetworkModel{
                    url: "/products/list"
                    filter: {"only_variants":true}
                    Component.onCompleted: requestData();
                    onDataRecevied: {
                        productsCB.dataReceived=true;
                    }
                }
            }

            CTextField{
                id: numpadInput
                //                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumWidth: numpad.width

                onAccepted:{
                    cashierModel.addProduct(text,true);
                    text=""
                }
                placeholderText: qsTr("Barcode...")
                implicitHeight: 60

            }
        }


        GridLayout{ //customer grid
            Layout.alignment: Qt.AlignCenter
            Layout.row: 1
            columnSpacing: 15
            Layout.column: 0
            columns: 2
            CComboBox{
                property bool isValid: currentText===editText
                id: customerCB;
                Layout.fillWidth: true;
                implicitHeight: 60
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
                        requestData();
                    }
                }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                icon.name: "cil-user"

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
            CTextField{
                id: phoneLE
                enabled: !customerCB.isValid

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: qsTr("Phone...")
                leftIcon: "cil-phone"
            }
            CTextField{
                id: addressLE
                enabled: !customerCB.isValid
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: qsTr("Address...")
                leftIcon: "cil-location-pin"
            }
            CTextField{
                Layout.alignment: Qt.AlignTop
                id: notesLE
                //id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: qsTr("Note...")
                leftIcon: "cil-notes"

            }
            CComboBox{
                id: cityCB
                enabled: deliverySwitch.checked

                property bool isValid: currentText===editText
                Layout.fillWidth: true;
                implicitHeight: 60
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                icon.name: "cil-location-pin"

                model: BarqLocationsModel{
                    id: cityModel
                    Component.onCompleted: requestData();
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

            CComboBox{
                id: townCB
                enabled: deliverySwitch.checked
                property bool isValid: currentText===editText
                Layout.fillWidth: true;
                implicitHeight: 60
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                icon.name: "cil-location-pin"



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
            Layout.maximumWidth: numpad.width
            Layout.row: 1
            Layout.column: 1



            CTextField{
                id: total
                readOnly: true
                text: Utils.formatNumber(cashierModel.total) + " IQD";
                Layout.fillWidth: true
                font.pixelSize: 20
                implicitHeight: 60

            }
            CButton{
                text: qsTr("Pay")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                Layout.fillWidth: true
                implicitHeight: 60
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
                checked: false
                text: qsTr("Barq Delivery")
                icon.source: "qrc:/images/icons/barq_logo.png"
                icon.color: "transparent"
                icon.height: 50
                Layout.fillWidth: true
            }



            function confirmPayment(){
                paymentDialog.amount=cashierModel.total;
                paymentDialog.paid=cashierModel.total;
                paymentDialog.open();
            }
        }//ColumnLayout
    } // GridLayout end
}



