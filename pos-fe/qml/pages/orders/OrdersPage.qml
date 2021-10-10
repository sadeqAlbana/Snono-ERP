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
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Card{

    title: qsTr("Orders")

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
            model: OrdersModel{
                id: model
            }

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
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
