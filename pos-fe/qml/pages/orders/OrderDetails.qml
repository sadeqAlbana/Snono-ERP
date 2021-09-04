import QtQuick 2.0
import QtQuick.Controls 2.5
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/tables"

import QtQuick.Layouts 1.12
import app.models 1.0
Popup{
    id: orderDetails

    modal: true
    parent: Overlay.overlay
    margins: 0
    padding: 0
    //width: parent.width
    //height: parent.height
    width: 700
    height: 500
    anchors.centerIn: parent;
    property var order;


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

         CTableView{

            anchors.fill: parent;

            model : OrderItemsModel{
                Component.onCompleted: {
                    setupData(order.pos_order_items)
                }
            }
        }
    }


}
