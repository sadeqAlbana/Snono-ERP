import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import Qt5Compat.GraphicalEffects
import CoreUI
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils
AppPage{
    title: qsTr("Customers")
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction{ text: qsTr("Add"); icon.name: "cil-plus.svg"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/customers/AddCustomerPage.qml");},

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

