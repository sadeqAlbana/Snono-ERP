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
        }

        PayBillDialog{
            id: dialog;

            onAccepted: {
                var billId= model.data(tableView.currentRow,"id");

                model.payBill(billId);
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

        AddCustomBillDialog{
            id: customBillDlg;
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction{enabled: tableView.currentRow>=0; text: qsTr("Pay"); icon.name: "cil-task"; onTriggered: {
                        dialog.amount=model.jsonObject(tableView.currentRow).total;
                        dialog.open();}},
//                Action{enabled: tableView.currentRow>=0; text: qsTr("Return"); icon.name: "cil-task"; onTriggered: {
//                        Api.returnBill(model.jsonObject(tableView.currentRow).id)
//                       }},
                CAction{ text: qsTr("New Bill"); icon.name: "cil-plus"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/AddVendorBillPage.qml");},
                CAction{ text: qsTr("New Custom Bill"); icon.name: "cil-medical-cross"; onTriggered: customBillDlg.open();},
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

            Connections{
                target: Api

                function onProcessCustomBillResponse(reply){
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                }
            }

            model: VendorsBillsModel{
                id: model;

                onCreateBillReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                }

                onPayBillReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                }


            } //model end



        }
    }
}

