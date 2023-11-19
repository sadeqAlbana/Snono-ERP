import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage{

    title: qsTr("Draft Orders")

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

        PayBillDialog{
            id: dialog;

            onAccepted: {
                var billId= model.data(tableView.currentRow,"id");

                Api.payBill(billId).subscribe(function(response){
                    if(response.json('status')===200){
                        model.refresh();
                    }
                });
            }
        }

        FileDialog {
            id: sheinDialog
            currentFolder: StandardPaths.writableLocation(
                               StandardPaths.DocumentsLocation)
            nameFilters: ["Json files (*.json)", "All files (*)"]
            onAccepted: {
                Api.addSheinOrder(selectedFile).subscribe(function(response){
                    console.log(JSON.stringify(response.json()));
                });
            }
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/orders/DraftOrderForm.qml",
                                                                                                {
                                                                                                                        "title": qsTr("Add")
                                                                                                                    })},

                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/orders/DraftOrderForm.qml",
                                                 {
                                                     "title": qsTr("Edit"),

                                                 "keyValue": model.jsonObject(tableView.currentRow).id
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_taxes";

                },
                CAction{ text: qsTr("Delete");
                    icon.name: "cil-delete";
                    onTriggered: Api.removeDraftOrder(model.data(tableView.currentRow,"id"))
                    .subscribe(function(response){
                                            if(response.json("status")===200){
                                                model.refresh();
                                            }
                                        })}
            ]


            delegate: AppDelegateChooser{
            }



            model: DraftOrdersModel{
                id: model;



            } //model end



        }
    }
}

