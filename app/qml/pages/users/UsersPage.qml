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
    title: qsTr("Users")
    StackView.onActivated: model.refresh();

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
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/users/UsersForm.qml",{"applyHandler": Api.addUser,
                                                     "title": qsTr("Add User")
                                                 })

                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/users/UsersForm.qml",
                                                 {"applyHandler": Api.updateUser,
                                                     "title": qsTr("Edit User"),

                                                 "initialValues":model.jsonObject(tableView.selectedRow)
                                                 })
                    enabled:tableView.validRow; permission: "prm_edit_users";

                },


                CAction{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: {}}
            ]//actions

            model: UsersModel{
                id: model

            }//model
        }//tableview
    }//layout
}//card

