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
import QtQuick.Pdf

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

            PdfMultiPageView{
                id: pdf
                clip: true
                anchors.fill: parent
                // width: sourceSize.width
                // height: sourceSize.height
                document: PdfDocument{
                    source: receiptData? "file:///"+ReceiptGenerator.createNew(receiptData) : ""

                    onStatusChanged:(status)=> {
                        if(status==PdfDocument.Ready){
                            if(Settings.receiptLinePrinter){
                                pdf.renderScale=2

                            }

                        }
                    }
                }

            }
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

            CComboBox{
                id: externalDelivery
                Layout.rightMargin: 10
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "value"
                currentIndex: 1
                model: ListModel{
                    ListElement{name: "No Delivery"; value: 0}
                    ListElement{name: "Baghdad";     value: 5000}
                    ListElement{name: "Provinces 7,000";  value: 7000}

                }
            }


        }

        function printReceipt(){
            if(externalDelivery.currentValue>0){
                let orderId=receiptData.id;
                console.log("order id: " + orderId)
                Api.barqReceipt(orderId); //need to deal with later!
                receiptData["external_delivery"]=externalDelivery.currentValue;
            }
            ReceiptGenerator.createNew(receiptData,true);
        }

    } //card end


}
