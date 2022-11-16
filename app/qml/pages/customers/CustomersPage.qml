import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils


import Qt5Compat.GraphicalEffects

import PosFe
AppPage{
    title: qsTr("Customers")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView
        }
        AddCustomerDialog{
            id: dialog;
            onAddedCustomer: model.requestData();
        }
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction{ text: qsTr("Add"); icon.name: "cil-plus.svg"; onTriggered: dialog.open();},

                CAction{ text: qsTr("Delete"); icon.name: "cil-delete.svg"; onTriggered: {}}
            ]//actions

            model: CustomersModel{
                id: model
                Component.onCompleted: {
                    requestData();
                }
            }//model
        }//tableview
    }//layout
}//card

