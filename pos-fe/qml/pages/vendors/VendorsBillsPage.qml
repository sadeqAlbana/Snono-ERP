import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import "qrc:/common"
Card{

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
                Action{enabled: tableView.selectedRow>=0; text: qsTr("Pay"); icon.name: "cil-task"; onTriggered: {
                        dialog.amount=model.jsonObject(tableView.selectedRow).total;
                        dialog.open();}},
                Action{ text: qsTr("New Bill"); icon.name: "cil-plus"; onTriggered: newBillDlg.open();},
                Action{ text: qsTr("New Custom Bill"); icon.name: "cil-medical-cross"; onTriggered: customBillDlg.open();}

            ]

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "status"; StatusDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
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

