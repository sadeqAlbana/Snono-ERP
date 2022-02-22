import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtGraphicalEffects 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"
import app.models 1.0

Card{

    title: qsTr("Orders Returns")
    padding: 15
    ColumnLayout{
        id: page
        anchors.fill: parent;

        RowLayout{
            spacing: 15

            CMenuBar{
                CMenu{
                    title: qsTr("Actions");
                    icon:"qrc:/icons/CoreUI/free/cil-settings.svg"
                    actions: tableView.actions
                }
            }

            Item{Layout.fillWidth: true}

            CTextField{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
                placeholderText: qsTr("Search...")
                rightIcon: "cil-search"
            }
        }//top layout end


        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}

            }

            actions: [
                //Action{ text: qsTr("Add"); icon.source: "qrc:/icons/CoreUI/free/cil-plus.svg"; onTriggered: {}},
                //Action{ text: qsTr("Delete"); icon.source: "qrc:/icons/CoreUI/free/cil-delete.svg"; onTriggered: {}}
            ]

            model: OrdersReturnsModel{
                id: model

            }//model end
        }//tableview end
    }//ColumnLayout end
}//card end

