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

    ColumnLayout{
        id: page
        anchors.fill: parent;
        anchors.margins: 20
        RowLayout{
            spacing: 15

            CMenuBar{
                CMenu{
                    title: qsTr("Actions");
                    icon:"qrc:/assets/icons/coreui/free/cil-settings.svg"
                    actions: tableView.actions
                }
            }

            Rectangle{
                Layout.fillWidth: true
                color: "transparent"
            }

            CTextField{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
                placeholderText: qsTr("Search...")
                rightDelegate : CTextField.Delegate{icon:"qrc:/assets/icons/coreui/free/cil-search.svg"}
            }
        }



        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                Action{ text: qsTr("Deposit Money"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: dialog.open();}]

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }

            model: AccountsModel{
                id: model;

                onDepositCashResponseReceived: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end

            } //model end

            DepositMoneyDialog{
                id: dialog

                onAccepted: model.depositCash(amount);

            }//dialog end




        }
    }
}

