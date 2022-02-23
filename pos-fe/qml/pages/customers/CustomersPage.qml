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
import "qrc:/common"

import QtGraphicalEffects 1.0
import app.models 1.0

Card{
    title: qsTr("Customers")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
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

                Action{ text: "Delete"; icon.name: "cil-delete.svg"; onTriggered: tableView.removeVendor()}
            ]//actions

            model: CustomersModel{
                id: model
            }//model
        }//tableview
    }//layout
}//card

