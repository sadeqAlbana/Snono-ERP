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

    title: qsTr("Vendors Bills")

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
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Details")
                    icon.name: "cil-notes"
                    onTriggered: {
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/vendors/VendorBillDetailsPage.qml",
                                    {
                                        "keyValue": model.jsonObject(
                                                        tableView.currentRow).id
                                    })
                    }
                },
                CAction{enabled: tableView.currentRow>=0; text: qsTr("Pay"); icon.name: "cil-task"; onTriggered: {
                        dialog.amount=model.jsonObject(tableView.currentRow).total;
                        dialog.open();}},
//                Action{enabled: tableView.currentRow>=0; text: qsTr("Return"); icon.name: "cil-task"; onTriggered: {
//                        Api.returnBill(model.jsonObject(tableView.currentRow).id)
//                       }},
                CAction{ text: qsTr("New Bill"); icon.name: "cil-plus"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/AddVendorBillPage.qml");},
                CAction{ text: qsTr("New Custom Bill"); icon.name: "cil-medical-cross"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/AddCustomVendorBillPage.qml");},
                CAction {
                    text: qsTr("Add Shein Order")
                    icon.name: "cil-cart"
                    onTriggered: sheinDialog.open()
                    permission: "prm_adjust_stock"
                }

            ]

            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "status"; StatusDelegate{}}
            }



            model: VendorsBillsModel{
                id: model;



            } //model end



        }
    }
}

