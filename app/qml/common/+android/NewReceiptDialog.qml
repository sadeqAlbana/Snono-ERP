import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    property var receiptData;
//    margins: 0
//    padding: 0
//    closePolicy: Popup.NoAutoClose
//    width: parent.width*0.3
    width: Screen.height>=1080? 600 : 400
    height: Screen.height>=1080? 900 : 600
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

        // Flickable{
        //     clip: true
        //     anchors.fill: parent;

        //     contentWidth: pdf.width;
        //     contentHeight: pdf.height
        //     ScrollBar.vertical: ScrollBar { }
        //     ScrollBar.horizontal: ScrollBar { }


       // }




        footer: RowLayout{
            clip: true
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




        }

        function printReceipt(){
                let orderId=receiptData.id;
                console.log("order id: " + orderId)
                if(receiptData.shipment.carrier.name=="Barq"){
                    Api.barqReceipt(orderId);
                }


            ReceiptGenerator.createDeliveryReceipt(receiptData,true);
        }

    } //card end


}
