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

    property int sessionId : -1

    RowLayout{
        anchors.fill: parent;
        anchors.margins: 20

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 500
            model: CashierModel{
                id: model

                onPurchaseResponseReceived: {
                    if(!res.status){
                        toastrService.push("Error",res.message,"error",2000)
                    }else{
                        paymentDialog.close();
                        receiptDialog.receiptData=res.order;
                        receiptDialog.open();
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
            }

        }
        ColumnLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true

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

            Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
            }

            CTextField{
                id: customerPhone
                Layout.fillWidth: true;
                implicitHeight: 60
            }

            CComboBox{
                id: customerCB;
                Layout.fillWidth: true;
                implicitHeight: 60
                model: CustomersModel{
                id: customersModel
                }
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                editable: true

                onCurrentValueChanged: {
                    console.log(currentText)
                    console.log(currentIndex);
                    tableView.model.updateCustomer(currentValue);
                    customerPhone.text=customersModel.data(customerCB.currentIndex,"phone")
                }

            }

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
            }

            function confirmPayment(){
                paymentDialog.amount=model.total;
                paymentDialog.paid=model.total;
                paymentDialog.open();
            }

            PayDialog{
                id: paymentDialog

                onAccepted: {
                    model.processCart(paid,tendered);
                }
            }

            ReceiptDialog{
                id: receiptDialog
            }

        } // ColumnLayout end


    }
}


