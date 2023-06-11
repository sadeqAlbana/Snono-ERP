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
    StackView.onActivated: model.refresh();

    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            view: tableView
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/customers/CustomerForm.qml",{"applyHandler": Api.addCustomer,
                                                     "title": qsTr("Add Customer")
                                                 })

                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/customers/CustomerForm.qml",
                                                 {"applyHandler": Api.updateCustomer,
                                                     "title": qsTr("Edit Customer"),

                                                 "initialValues":model.jsonObject(tableView.currentRow)
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_customers";

                },


                CAction{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: {}}
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

