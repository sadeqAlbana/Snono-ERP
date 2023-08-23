import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI.Palettes
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import JsonModels
//https://doc.qt.io/qt-6/qtquick-tutorials-dynamicview-dynamicview2-example.html

//https://raymii.org/s/tutorials/Qml_Drag_and_Drop_example_including_reordering_the_Cpp_Model.html
//https://stackoverflow.com/questions/36449029/how-to-drag-an-item-outside-a-listview-in-qml
import PosFe

AppPage {
    id: page

    StackView.onActivated: model.refresh();


    title: qsTr("Permissions")
    ColumnLayout {
        anchors.fill: parent

        AppToolBar{
            view: view

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

        }

        CTableView {
            id: view
            implicitHeight: 400
            implicitWidth: 300
            Layout.fillWidth: true
            Layout.fillHeight: true
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/users/AclGroupForm.qml",{"applyHandler": Api.addAclGroup,
                                                     "title": qsTr("Add Group")
                                                 })
                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/users/AclGroupForm.qml",
                                                 {"applyHandler": Api.updateAclGroup,
                                                     "title": qsTr("Edit Group"),

                                                 "initialValues":model.jsonObject(view.currentRow)
                                                 })
                    enabled:view.currentRow>=0; permission: "prm_edit_acl_groups";

                },


                CAction{ text: qsTr("Delete");
                    icon.name: "cil-delete";
                    onTriggered: Api.deleteAclGroup(model.data(view.currentRow,"id"))
                    .subscribe(function(response){
                                            if(response.json("status")===200){
                                                model.refresh();
                                            }
                                        })}
            ]//actions



            model: AclGroupsModel {
                id: model
                checkable: true
//                onDataRecevied: page.updateChecked() //method has a flow if model is received before cb model
                sortKey: "id"
                direction: "desc"

            }
        }


    }//layout

    footer: CDialogButtonBox{
        alignment: Qt.AlignRight | Qt.AlignVCenter
        position: DialogButtonBox.Footer
        spacing: 15


        onReset: model.requestData();

        onApplied: {

            let groupId=roleCB.currentValue
            let items=aclItemsModel.toJsonArray(Qt.Checked)

            console.log("items: "  + JSON.stringify(items))
            let response=Api.updateGroupItems(groupId,items).subscribe(function(response){
                if(response.json("status")===200){
                    aclGroupsModel.refresh();
                }
            });

        }


        background: RoundedRect{
            radius: CoreUI.borderRadius
            border.color: palette.shadow
            topLeft: false
            topRight: false
            color: CoreUI.color(CoreUI.CardHeader)
            border.width: 1
        }
        CButton{
            text: qsTr("Apply")
            palette: BrandSuccess{}
            DialogButtonBox.buttonRole: DialogButtonBox.ApplyRole
        }

        CButton{
            text: qsTr("Cancel")
            palette: BrandDanger{}
            DialogButtonBox.buttonRole: DialogButtonBox.Cancel
            onClicked: Router.back();
        }

        CButton{
            text: qsTr("Reset")
            palette: BrandWarning{}
            DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
        }

    }
} //card end
