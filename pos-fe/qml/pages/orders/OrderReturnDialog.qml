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
    Connections{
    target: App;
    function onAboutToQuit(){
        dialog.destroy();
    }
}

    id: dialog
    modal: true
    anchors.centerIn: parent;
    property var order;
    signal accepted(var orderId, var items);
    onAccepted: close();
    onClosed: destroy();
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
        title: qsTr("Return Order")
        anchors.fill: parent;

        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10

            spacing: 10

            OrderReturnListView{
                id: returnListView
                Layout.fillHeight: true
                Layout.fillWidth: true
                order: dialog.order

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
                text: qsTr("Return")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.accepted(order.id,returnListView.returnedItems());
            }

        } //footer end

//        function purchaseStock(){
//            var vendor=vendorsCB.currentValue;
//            var products=cartListView.vendorCartModel.toJsonArray();
//            accepted(vendor,products);
//        }

    } //card End


}
