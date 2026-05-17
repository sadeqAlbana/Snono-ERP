import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
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

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            CLabel {
                text: qsTr("Return from")
            }

            CFilterComboBox {
                id: returnAccountCB
                Layout.preferredWidth: 400
                Layout.fillWidth: true
                dataUrl: "/accounts/list"
                filter: {"type":"liquidity"}
                textRole: "name"
                valueRole: "id"
            }
        }

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
            enabled: returnAccountCB.currentValue !== undefined && returnAccountCB.currentValue !== null
            onClicked: Api.returnOrder(order.id, returnAccountCB.currentValue, returnListView.returnedItems())
        }
    } //footer end
}
