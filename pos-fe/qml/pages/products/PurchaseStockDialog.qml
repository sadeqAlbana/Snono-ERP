import QtQuick 2.0
import QtQuick.Controls 2.5
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/buttons"


import QtQuick.Layouts 1.12
import app.models 1.0
Popup{
    id: dialog

    onOpened: quantity.input.text="1"


    modal: true
    parent: Overlay.overlay
    margins: 0
    padding: 0
    //width: parent.width
    //height: parent.height
    width: 700
    height: 500
    anchors.centerIn: parent;
    property var product;
    signal accepted(var quantity);


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
        title: qsTr("Order Details")
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10
            CTextFieldGroup{id: quantity; label.text: qsTr("Quantity");    input.text:"1"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}

            CTextFieldGroup{id: total;    label.text: qsTr("Total"); input.text: product ? parseInt(quantity.input.text)*product.cost : "0";      input.readOnly: true; }
        }



        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Close")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Purchase")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.accepted(parseInt(quantity.input.text));
            }


        }

    } //card end

}
