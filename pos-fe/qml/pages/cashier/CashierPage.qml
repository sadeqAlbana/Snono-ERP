import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/common"
import QtQuick.Controls 1.4 as TT
import QtGraphicalEffects 1.0

import QtQuick.Controls.Styles 1.4 as TS
import app.models 1.0
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0

Page{
    title: qsTr("Cashier")
    background: Rectangle{
        color: "transparent"
    }
    property bool pay: false

    property int sessionId : -1

    GridLayout{
        anchors.fill: parent;
        anchors.margins: 20
        rows: 2
        columns: 2
        flow: GridLayout.LeftToRight
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 500
            model: CashierModel{
                id: model


                onDataRecevied: {
                    if(pay){
                        //console.log("pay !!!")
                        model.processCart(model.total,0,notesLE.text);
                        pay=false
                    }
                }

                onPurchaseResponseReceived: {
                    if(!res.status){
                        toastrService.push("Error",res.message,"error",2000)
                    }else{
                        paymentDialog.close();
                        toastrService.push("Success",res.message,"success",2000)
                        receiptDialog.receiptData=res.order;
                        receiptDialog.open();
                        if(customerCB.currentIndex<0){
                            customersModel.refresh();
                        }
                        notesLE.text=""
                    }
                }

                onUpdateCustomerResponseReceived: {
                    if(res.status===200){
                        toastrService.push("Success",res.message,"success",2000)

                    }else{
                        toastrService.push("Error",res.message,"error",2000)

                    }
                }


                onAddProductReply: {
                    if(res.status===200){
                        scannerBeep.play()
                    }else{
                        toastrService.push("Warning",res.message,"warning",2000)

                    }
                }
            }



            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{roleValue: "percentage"; SuffixDelegate{suffix: "%"}}
            }

        }



        ColumnLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            //            Layout.rowSpan: 2
            Numpad{
                id: numpad


                enabled: tableView.selectedRow>=0
                //                Layout.fillHeight: true
                Layout.fillWidth: true
                //                Layout.maximumHeight: implicitHeight
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
                    modelValue=model.data(tableView.selectedRow,model.indexOf(key));

                    var newValue=NumberEditor.appendDigit(parseFloat(modelValue),digit,waitingForDecimal);
                    model.setData(row,key,newValue);
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
                    var modelValue=model.data(tableView.selectedRow,model.indexOf(key));
                    if(modelValue===0 && activeButton.text==="Qty"){
                        clearClicked();
                    }else{
                        var newValue=NumberEditor.removeDigit(modelValue);
                        model.setData(row,key,newValue);

                    }
                }
                function clearClicked(){
                    model.removeProduct(tableView.selectedRow);
                }
            }
            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }

            CTextInput{
                id: numpadInput
                //                Layout.fillHeight: true
                Layout.fillWidth: true
                onAccepted:{
                    model.addProduct(text);
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
                    onDataRecevied: {
                        customerCB.currentIndex=0
                    }

                    onAddCustomerReply: {
                        if(reply.status===200){
                            model.updateCustomer(reply.customer.id)
                            //customerCB.currentIndex=model.rowCount()-1;
                        }
                    }
                }


                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true
                leftIcon: "qrc:/assets/icons/coreui/free/cil-user.svg"

                //                onCurrentValueChanged: {
                //                    //console.log(currentText)
                //                    //console.log(currentIndex);

                //                }
                onEditTextChanged: {
                    //                    console.log("edit text: " + customerCB.editText );
                    //                    console.log("current text: "+ customerCB.currentText)
                    //                    console.log("current value: " + customerCB.currentValue)
                    //                    console.log("current index: " + customerCB.currentIndex)

                }
//                onCurrentTextChanged: {
//                    console.log("current text:   " + currentText)
//                }

                onCurrentIndexChanged: {
                    //console.log("onCurrentIndexChanged: " + customerCB.currentIndex)
                    if(currentIndex>=0){
                        var currentCustomer=customersModel.jsonObject(customerCB.currentIndex);
                        phoneLE.text=customersModel.jsonObject(customerCB.currentIndex).phone
                        addressLE.text=customersModel.jsonObject(customerCB.currentIndex).address
                        //console.log("current value: " + currentValue)
                        tableView.model.updateCustomer(currentCustomer.id);
                        //                        customerPhone.text=customersModel.data(customerCB.currentIndex,"phone")
                    }else{
                        phoneLE.text=""
                        addressLE.text=""
                    }

                }
                //                onAcceptableInputChanged: {
                //                    console.log("acceptable: " + acceptableInput)
                //                }


                onActiveFocusChanged: {
                    var edit=editText
                    if(!activeFocus && editText!=currentText){
                        currentIndex=-1;
                    }
                    editText=edit;
                }


            }
            CTextField{
                Layout.alignment: Qt.AlignTop
                enabled: !customerCB.isValid
                id: phoneLE
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: "Phone..."
                leftIcon: "qrc:/assets/icons/coreui/free/cil-phone.svg"

            }
            CTextField{
                Layout.alignment: Qt.AlignTop
                id: addressLE
                enabled: !customerCB.isValid

                //id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: "Address..."
                leftIcon: "qrc:/assets/icons/coreui/free/cil-location-pin.svg"

            }
            CTextField{
                Layout.alignment: Qt.AlignTop
                id: notesLE
                //id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 60
                placeholderText: "Note..."
                leftIcon: "qrc:/assets/icons/coreui/free/cil-notes.svg"

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
                text: Utils.formatNumber(model.total) + " IQD";
                //                Layout.fillHeight: true
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
                enabled: model.total>0
            }
            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }
            ReceiptDialog{
                id: receiptDialog
            }

            function confirmPayment(){
                paymentDialog.amount=model.total;
                paymentDialog.paid=model.total;
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
                        model.processCart(paid,tendered,notesLE.text);
                    }

                }
            }
        }

    } // GridLayout end


}



