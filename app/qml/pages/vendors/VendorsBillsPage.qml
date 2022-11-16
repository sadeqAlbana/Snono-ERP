import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects

import Qt.labs.qmlmodels 1.0
import PosFe
AppPage{

    title: qsTr("Vendors Bills")

    ColumnLayout{
        id: page
        anchors.fill: parent;
        anchors.margins: 20
        AppToolBar{
            id: toolBar
            tableView: tableView
        }

        PayBillDialog{
            id: dialog;

            onAccepted: {
                var billId= model.data(tableView.selectedRow,"id");

                model.payBill(billId);
            }
        }

        PurchaseStockDialog{
            id: newBillDlg
            onAccepted: {
                model.createBill(vendorId,products);
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
                CAction{enabled: tableView.selectedRow>=0; text: qsTr("Pay"); icon.name: "cil-task"; onTriggered: {
                        dialog.amount=model.jsonObject(tableView.selectedRow).total;
                        dialog.open();}},
//                Action{enabled: tableView.selectedRow>=0; text: qsTr("Return"); icon.name: "cil-task"; onTriggered: {
//                        Api.returnBill(model.jsonObject(tableView.selectedRow).id)
//                       }},
                CAction{ text: qsTr("New Bill"); icon.name: "cil-plus"; onTriggered: newBillDlg.open();},
                CAction{ text: qsTr("New Custom Bill"); icon.name: "cil-medical-cross"; onTriggered: customBillDlg.open();}

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

