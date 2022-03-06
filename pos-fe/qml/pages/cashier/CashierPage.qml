import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as TT
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4 as TS
import Qt.labs.qmlmodels 1.0

import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"
import app.models 1.0

Page{
    title: qsTr("Cashier")
    //    palette.window: "transparent"
    background: Rectangle{color: "transparent"}
    padding: 10
    property bool pay: false
    property int sessionId : -1
    GridLayout{
        anchors.fill: parent;
        rows: 2
        columns: 2
        flow: GridLayout.LeftToRight
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 500
            model: CashierModel{
                id: cashierModel
                onPurchaseResponseReceived: {
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
                onUpdateCustomerResponseReceived: {
                    if(res.status===200){
                        if(pay){
                            cashierModel.processCart(cashierModel.total,0,notesLE.text);
                            pay=false
                        }
                    }
                }//onUpdateCustomerResponseReceived
                onAddProductReply: {
                    if(res.status===200){
                        scannerBeep.play()
                        productsCB.currentIndex=-1;

                    }/*else{
                        toastrService.push("Warning",res.message,"warning",2000)
                    }*/
                }//onAddProductReply
            }

            delegate: AppDelegateChooser{}
        }

        ColumnLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            //            Layout.rowSpan: 2
            Numpad{
                id: numpad
                enabled: tableView.selectedRow>=0
                Layout.fillWidth: true
                property bool waitingForDecimal: false
                property var decimalBtn;

                Component.onCompleted: {
                    decimalBtn=numpad.button(".");
                    decimalBtn.enabled=Qt.binding(function(){return !waitingForDecimal})
                    decimalBtn.clicked.connect(function(){waitingForDecimal=true})
                }

                onButtonClicked: {
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
                    case "Qty": key="qty"; break;
                    case "Price": key="unit_price"; break;
                    case "Disc": key="discount"; break;

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
                    case "Qty": key="qty"; break;
                    case "Price": key="unit_price"; break;
                    case "Disc": key="discount"; break;

                    default: break;
                    }
                    var modelValue=cashierModel.data(tableView.selectedRow,cashierModel.indexOf(key));
                    if(modelValue===0 && activeButton.text==="Qty"){
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
            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }





            CComboBox{
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
                    Component.onCompleted: requestData();
                    onDataRecevied: {
                        productsCB.dataReceived=true;
                    }
                }
            }

            CTextInput{
                id: numpadInput
                //                Layout.fillHeight: true
                Layout.fillWidth: true
                onAccepted:{
                    cashierModel.addProduct(text,true);
                    text=""
                }
                placeholderText: qsTr("Barcode...")
                implicitHeight: 60

            }
        }

        GridLayout{
            columns: 2
            Layout.fillHeight: true
            CComboBox{
                property bool isValid: currentText===editText
                id: customerCB;
                Layout.fillWidth: true;
                implicitHeight: 60
                model: CustomersModel{
                    id: customersModel
                    onAddCustomerReply: {
                        if(reply.status===200){
                            cashierModel.updateCustomer(reply.customer.id)
                        }
                    }
                }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon: "cil-user"

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
                placeholderText: "Phone..."
                leftIcon: "cil-phone"
            }
            CTextField{
                id: addressLE
                enabled: !customerCB.isValid
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: "Address..."
                leftIcon: "cil-location-pin"
            }
            CTextField{
                Layout.alignment: Qt.AlignTop
                id: notesLE
                //id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: "Note..."
                leftIcon: "cil-notes"

            }
            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
                Layout.columnSpan: 2
            }
        }


        ColumnLayout{
            CTextInput{
                id: total
                readOnly: true
                text: Utils.formatNumber(cashierModel.total) + " IQD";
                Layout.fillWidth: true
                font.pixelSize: 20
                implicitHeight: 60

            }
            CButton{
                text: qsTr("Pay")
                color: "#2eb85c"
                textColor: "#ffffff"
                Layout.fillWidth: true
                implicitHeight: 60
                onClicked: parent.confirmPayment();
                enabled: tableView.rows>0
            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            ReceiptDialog{
                id: receiptDialog
            }//receiptDialog

            function confirmPayment(){
                paymentDialog.amount=cashierModel.total;
                paymentDialog.paid=cashierModel.total;
                paymentDialog.open();
            }

            PayDialog{
                id: paymentDialog
                onAccepted: {
                    if(customerCB.currentIndex<0){
                        //update customer then process cart
                        pay=true
                        customersModel.addCustomer(customerCB.editText,"","","",phoneLE.text,addressLE.text)
                    }else{
                        cashierModel.processCart(paid,tendered,notesLE.text);
                    }
                }//accepted
            }//payDialog
        }//ColumnLayout
    } // GridLayout end
}



