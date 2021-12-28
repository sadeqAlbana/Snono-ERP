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
import "qrc:/screens/Utils.js" as Utils

Popup{
    id: dialog
    signal addVendor(string name, string email, string address, string phone);
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    width: 900
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
        title: qsTr("New Bill")
        anchors.fill: parent;

        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10

        RowLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true

            CComboBox{
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                model: VendorsModel{

                }
            }

            spacing: 30

        }
            spacing: 10

            VendorBillListView{
                Layout.fillHeight: true
                Layout.fillWidth: true

            }
        }



//        ColumnLayout{
//            anchors.margins: 10
//            anchors.fill: parent;
//            spacing: 10





            //            component OrderLine:    Rectangle{z


//        }



        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Close")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Purchase")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: card.addVendor();
            }

        } //footer end

    } //card End


}
