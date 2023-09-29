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
            view: tableView

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

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

                                                 "keyValue": model.jsonObject(tableView.currentRow).id
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_users";

                },


                CAction{ text: qsTr("Delete");
                    icon.name: "cil-delete";
                    onTriggered: Api.deleteUser(model.data(tableView.currentRow,"id"))
                    .subscribe(function(response){
                                            if(response.json("status")===200){
                                                model.refresh();
                                            }
                                        })}
            ]//actions

            model: UsersModel{
                id: model

            }//model
        }//tableview
    }//layout
}//card

