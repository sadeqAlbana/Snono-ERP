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
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay

    signal accepted(var status);


    onAccepted: close();


    width: 850
    height: parent.height*0.7
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
        title: qsTr("Return Order")
        anchors.fill: parent;
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10

            CTableView{
               rowHeightProvider: function(row){return 50}
               Layout.fillWidth: true
               Layout.fillHeight: true
               delegate: DelegateChooser{
                   role: "delegateType"
                   DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                   DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
               }

               model : OrderItemsModel{
                   Component.onCompleted: {
                       setupData(order.pos_order_items)
                   }
               }
           }

        }

        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Cancel")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Update")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.accepted(cb.comboBox.currentValue);
            }
        } //footer end

    } //card end


}
