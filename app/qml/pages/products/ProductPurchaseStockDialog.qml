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
    signal accepted(var quantity, var vendorId);


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
        title: qsTr("Purchase Stock")
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10
            CTextFieldGroup{id: quantity; label.text: qsTr("Quantity");    input.text:"1"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}

            CTextFieldGroup{id: total;    label.text: qsTr("Total"); input.text: product ? Utils.formatNumber(parseInt(quantity.input.text)*product.cost) + " IQD" : "0 IQD";      input.readOnly: true; }

            CComboBoxGroup{
                id: vendorsCB
                Layout.fillWidth: true
                label.text: "Vendor"
                comboBox.textRole: "name"
                comboBox.valueRole: "id"
                comboBox.model: VendorsModel{}
                comboBox.currentIndex: 0

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


            }
            CButton{
                text: qsTr("Purchase")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.accepted(parseInt(quantity.input.text), vendorsCB.comboBox.currentValue);
            }


        }

    } //card end

}
