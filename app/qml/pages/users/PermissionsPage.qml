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



    function updateChecked(){
        let aclItems = aclGroupsModel.data(roleCB.currentIndex, "items")
        aclItemsModel.uncheckAll()
        aclItemsModel.matchChecked(aclItems, "permission", "permission")
    }
    title: qsTr("Permissions")
    ColumnLayout {
        anchors.fill: parent

        AppToolBar{
            tableView: listView
        }



        CComboBox {
            id: roleCB
            implicitWidth: 300
            Layout.fillWidth: true

            model: AclGroupsModel {
                id: aclGroupsModel
                onDataRecevied: page.updateChecked() //method has a flow if model is received before cb model

                Component.onCompleted: requestData()
            }
            valueRole: "id"
            textRole: "name"
            currentIndex: 0

            onCurrentIndexChanged: page.updateChecked();


        }

        CheckableListView {
            id: listView
            implicitHeight: 400
            implicitWidth: 300
            Layout.fillWidth: true
            Layout.fillHeight: true

            section.property: "category"
            section.delegate: Label {
                padding: 10
                text: section
                font.bold: true
            }

            delegate: CheckableListView.CListViewCheckDelegate {
                text: model.permission
            }


            model: AclItemsModel {
                id: aclItemsModel
                checkable: true
                onDataRecevied: page.updateChecked() //method has a flow if model is received before cb model
                sortKey: "category"
                direction: "desc"

                Component.onCompleted: requestData()
            }
        }


    }//layout

    footer: CDialogButtonBox{
        alignment: Qt.AlignRight | Qt.AlignVCenter
        position: DialogButtonBox.Footer
        spacing: 15


        onReset: aclItemsModel.requestData();

//        onApplied: {
//            if(!form.validate()){
//                return;
//            }

//            let handler=form.applyHandler;
//            handler(form.data()).subscribe(function(reply){ //this stays like that until it becomes part of CoreUIQml
//                        if(reply.status()===200){
//                            Router.back();
//                        }
//                    });
//        }


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
