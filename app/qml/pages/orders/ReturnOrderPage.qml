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
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage {
    id: page
    title: qsTr("Return Order")
    required property var order;

    // CashOnHand GL account id — kept in sync with MainAccount::CashOnHand on the backend.
    // Used to decide when to gate the refund on an open POS session + drawer balance.
    readonly property int  cashOnHandId: 19

    // Filled in from /posssession/current. Null when no session is open on this machine.
    property var openSession: null
    readonly property real drawerBalance:    openSession ? (openSession.cash_balance ?? 0) : 0
    readonly property bool hasOpenSession:   openSession !== null
    readonly property bool isCashFromDrawer: returnAccountCB.currentValue === page.cashOnHandId
    readonly property real returnTotal:      returnListView.returnTotal
    readonly property bool drawerInsufficient: page.isCashFromDrawer && page.returnTotal > page.drawerBalance
    readonly property bool noSessionForCash:   page.isCashFromDrawer && !page.hasOpenSession

    Component.onCompleted: {
        NetworkManager.get("/posssession/current").subscribe(function(res){
            var reply = res.json()
            if (reply.status === 200) {
                page.openSession = reply.pos_session
            }
        })
    }

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

            CLabel {
                visible: page.isCashFromDrawer && page.hasOpenSession
                text: qsTr("Drawer: %1").arg(Utils.formatCurrency(page.drawerBalance))
                color: page.drawerInsufficient ? "#e55353" : "#444"
                font.bold: true
            }
        }

        CLabel {
            visible: page.noSessionForCash
            Layout.fillWidth: true
            color: "#e55353"
            wrapMode: Text.Wrap
            text: qsTr("Open a POS session on this machine before refunding cash from the drawer.")
        }
        CLabel {
            visible: page.drawerInsufficient && page.hasOpenSession
            Layout.fillWidth: true
            color: "#e55353"
            wrapMode: Text.Wrap
            text: qsTr("Insufficient cash in drawer: %1 available, %2 requested.")
                    .arg(Utils.formatCurrency(page.drawerBalance))
                    .arg(Utils.formatCurrency(page.returnTotal))
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
            enabled: returnAccountCB.currentValue !== undefined
                  && returnAccountCB.currentValue !== null
                  && !page.noSessionForCash
                  && !page.drawerInsufficient
            onClicked: Api.returnOrder(order.id, returnAccountCB.currentValue, returnListView.returnedItems())
        }
    } //footer end
}
