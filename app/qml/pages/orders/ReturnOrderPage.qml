import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import CoreUI

AppPage {
    id: page
    title: qsTr("Return Order")
    required property var order;

    Connections{
        target: Api

        function onReturnOrderResponse(reply) {
            if(reply.status===200){
                Router.back();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        OrderReturnListView {
            id: returnListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            orderId: page.order.id
        }
    }



    footer: RowLayout {

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
        }

        CButton {
            text: qsTr("Close")
            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: Router.back();
        }
        CButton {
            text: qsTr("Return")
            palette.button: "#2eb85c"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: Api.returnOrder(order.id, returnListView.returnedItems())
        }
    } //footer end
}
