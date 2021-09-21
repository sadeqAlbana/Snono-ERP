import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtGraphicalEffects 1.0
import app.models 1.0

Popup{

    id: dialog
    signal addVendor(string name, string email, string address, string phone);
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    width: parent.width*0.6
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
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Add")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: card.addVendor();
            }

        } //footer end

    } //card End


}