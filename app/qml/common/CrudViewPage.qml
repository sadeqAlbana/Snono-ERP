import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import PosFe

BasicViewPage {
    id: page
    required property string basePath;
    required property string formFile;
    property string deletePath; //used in conjunction with deleteCB
    property var deleteCB: function(){

            NetworkManager.deleteResource(page.deletePath,model.data(tableView.currentRow,"id"))
            .subscribe(function(response){
                                    if(response.json("status")===200){
                                        model.refresh();
                                    }
                                });
    }
    property string addPermission: "";
    property string editPermission: "";
    property string deletePermission: "";
    actions: [
        CAction {
            text: qsTr("Add")
            icon.name: "cil-plus"
            onTriggered: Router.navigate(
                             page.basePath+"/"+page.formFile, {
                                 "title": qsTr("Add")
                             })
            permission: page.addPermission;
        },

        CAction {
            text: qsTr("Edit")
            icon.name: "cil-pen"
            onTriggered: Router.navigate(
                             page.basePath+"/"+page.formFile, {
                                 "title": qsTr("Edit"),
                                 "keyValue": page.model.jsonObject(
                                                 page.view.currentRow).id
                             })
            enabled: page.view.currentRow >= 0
            permission: page.editPermission
        },
        CAction {
            text: qsTr("Delete")
            icon.name: "cil-delete"
            permission: page.deletePermission
            onTriggered: page.deleteCB();
        }
    ]
}
