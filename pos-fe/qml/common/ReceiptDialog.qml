import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay


    property var receiptData;
//    margins: 0
//    padding: 0
//    closePolicy: Popup.NoAutoClose
    width: parent.width*0.3
    height: parent.height*0.8
    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Card{
        id: card
        title: qsTr("Receipt")
        anchors.fill: parent;


        ScrollView{
            clip: true
            anchors.fill: parent;
            contentWidth: availableWidth
            Image {
                anchors.fill: parent;
                source: receiptData? ReceiptGenerator.generateReceiptUrl(receiptData) : ""
                fillMode: Image.PreserveAspectFit

            }
        }




        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Close")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.close();
                implicitWidth: 80



            }
            CButton{
                implicitWidth: 80
                text: qsTr("Print")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10

                onClicked: card.printReceipt();
            }

            CComboBox{
                id: externalDelivery
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "value"
                currentIndex: 1
                model: ListModel{
                    ListElement{name: "No Delivery"; value: 0}
                    ListElement{name: "Baghdad";     value: 5000}
                    ListElement{name: "Provinces ";  value: 10000}
                }
            }


        }

        function printReceipt(){

            if(externalDelivery.currentValue>0){
                receiptData["external_delivery"]=externalDelivery.currentValue;
            }
            ReceiptGenerator.printReceipt(receiptData);
        }

    } //card end


}
