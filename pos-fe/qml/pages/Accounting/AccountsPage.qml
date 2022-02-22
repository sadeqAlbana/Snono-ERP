import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import app.models 1.0
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Card{
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

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: AccountsModel{ id: model;}
            actions: [Action{ text: qsTr("Deposit Money"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: dialog.open();}]
            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            } //delegate
        }//tableview
    } //layout
} //page

