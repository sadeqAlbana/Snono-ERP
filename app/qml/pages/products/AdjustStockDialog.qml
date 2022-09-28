import QtQuick 2.0
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Views
import CoreUI.Forms
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils


import QtQuick.Layouts
import App.Models 1.0
Popup{
    id: dialog

    property int originalQty
    property int productId;

    modal: true
    parent: Overlay.overlay
    margins: 0
    padding: 0
    //width: parent.width
    //height: parent.height
    width: 700
    height: 500
    anchors.centerIn: parent;
    signal accepted(var quantity, var reason);


    //closePolicy: Popup.NoAutoClose
    background: Rectangle{color: "transparent"}


    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Card{
        width: 700
        height: 500
        anchors.centerIn: parent;
        title: qsTr("Adjust Stock")
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10
            CTextFieldGroup{id: quantity; label.text: qsTr("New Quantity");    input.text:parseInt(originalQty); input.validator: DoubleValidator{bottom: 0;top:1000000000}}
            CTextFieldGroup{id: reason;    label.text: qsTr("Reason") }

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


            }
            CButton{
                text: qsTr("Adjust")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.accepted(productId,parseInt(quantity.input.text));
            }


        }

    } //card end

}
