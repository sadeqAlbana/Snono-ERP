import QtQuick;import QtQuick.Controls.Basic;

import QtQuick.Layouts
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import App.Models 1.0

Popup{

    id: dialog
    signal addVendor(string name, string email, string address, string phone);
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    width: 600
    height: 600
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
        title: qsTr("Add Vendor")
        anchors.fill: parent;

        ColumnLayout{
            anchors.margins: 10
            anchors.fill: parent;

            spacing: 10

            CTextFieldGroup{id: nameTF; label.text: "Name"}
            CTextFieldGroup{id: emailTF; label.text: "Email"}
            CTextFieldGroup{id: addressTF; label.text: "Address"}
            CTextFieldGroup{id: phoneTF; label.text: "Phone"}


            VendorsModel{
                id: model;
            }
        }

        function addVendor(){
            var name=nameTF.input.text;
            var email=emailTF.input.text;
            var address=addressTF.input.text;
            var phone=phoneTF.input.text;
            dialog.addVendor(name,email,address,phone);
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
                text: qsTr("Add")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: card.addVendor();
            }

        } //footer end

    } //card End


}
