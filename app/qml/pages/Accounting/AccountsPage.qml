import QtQuick;
import QtQuick.Layouts

import QtQuick.Controls.Basic;
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils


AppPage{
    title: qsTr("Accounts")
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
            view: tableView

            advancedFilter:  [
                {"type": "date","label": qsTr("from"),"key": "from"},
                {"type": "date","label": qsTr("to"),"key": "to"}

            ]
            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

            onFilterClicked: (filter) => {
                                 model.filter=filter
                                 model.requestData();
                             }

        }//toolBar
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: AccountsModel{ id: model;}
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/Accounting/AccountForm.qml",{
                                                     "title": qsTr("Add Account")
                                                 })

                },
                CAction{ text: qsTr("Deposit Money"); icon.name: "cil-dollar"; onTriggered: dialog.open();}
            ]
            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }
        }//tableview
    } //layout
} //page

