import QtQuick;import QtQuick.Controls.Basic;

import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import "qrc:/screens/Utils.js" as Utils

Popup{
    id: dialog
    modal: true
    anchors.centerIn: parent;
    signal accepted(var vendorId, var products);
    parent: Overlay.overlay
    width: 900
    height: 900
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
                id: vendorsCB
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
                id: cartListView
                Layout.fillHeight: true
                Layout.fillWidth: true

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
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Purchase")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: card.purchaseStock();
            }

        } //footer end

        function purchaseStock(){
            var vendor=vendorsCB.currentValue;
            var products=cartListView.vendorCartModel.toJsonArray();
            accepted(vendor,products);
        }

    } //card End


}
