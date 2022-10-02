import QtQuick;
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic;
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl

import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils


AppPage{
    title: qsTr("Accounts")
    padding: 10
    Connections{
        target: Api
        function onDepositCashResponseReceived(reply) {
            if(reply.status===200){
                model.requestData();
            }
        } //slot end
    }//connections
    DepositMoneyDialog{
        id: dialog
        onAccepted: Api.depositCash(amount);
    }//dialog
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView

        }//toolBar
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: AccountsModel{ id: model;}
            actions: [Action{ text: qsTr("Deposit Money"); icon.name: "cil-dollar"; onTriggered: dialog.open();}]
            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }
        }//tableview
    } //layout
} //page

