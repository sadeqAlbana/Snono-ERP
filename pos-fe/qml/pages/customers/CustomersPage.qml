import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

import Qt5Compat.GraphicalEffects
import App.Models 1.0

Card{
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
                Action{ text: qsTr("Add"); icon.name: "cil-plus.svg"; onTriggered: dialog.open();},

                Action{ text: "Delete"; icon.name: "cil-delete.svg"; onTriggered: {}}
            ]//actions

            model: CustomersModel{
                id: model
            }//model
        }//tableview
    }//layout
}//card

