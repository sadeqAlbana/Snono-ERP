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

import "qrc:/screens/Utils.js" as Utils

Card{

    title: qsTr("Orders")

    ColumnLayout{
        id: page

        //clip: true
        anchors.fill: parent;
        //anchors.margins: 20
        RowLayout{
            //Layout.fillWidth: true
            //Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 15

            Rectangle{
                Layout.fillWidth: true
                //Layout.fillHeight: true
                color: "transparent"
            }

            Label{
                text: qsTr("Search")
                font.pixelSize: 18
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            }

            TestTextField{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
                //                onTextChanged: {
                //                    ActivitiesModel.setFilter("reference like '"+text+"%'");
                //                }
            }


        }
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: OrdersModel{
                id: model
            }

            actions: [
                Action{ text: "Details"; icon.source: "qrc:/assets/icons/coreui/free/cil-info.svg"; onTriggered: {
                        var dialog=Utils.createObject("qrc:/pages/orders/OrderDetails.qml",
                                                      tableView,{order: model.jsonObject(tableView.selectedRow)});
                        dialog.open();
                    } }
            ]
        }

    }
}
