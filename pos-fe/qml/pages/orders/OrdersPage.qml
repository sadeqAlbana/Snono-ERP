import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtGraphicalEffects 1.0

import app.models 1.0
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Card{

    title: qsTr("Orders")

    ColumnLayout{
        id: page

        anchors.fill: parent;
        anchors.margins: 20
        RowLayout{
            spacing: 15



            UpdateDeliveryStatusDialog{
                id: deliveryStatusDialog;

                onAccepted: {
                    model.updateDeliveryStatus(model.jsonObject(tableView.selectedRow).id,status);

                }
            }

            CMenuBar{
                CMenu{
                    title: qsTr("Actions");
                    icon:"qrc:/icons/CoreUI/free/cil-settings.svg"
                    actions: tableView.actions
                }
            }

                Rectangle{
                    Layout.fillWidth: true
                    color: "transparent"
                }


                CTextField{
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 300
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    font.pixelSize: 18
                    placeholderText: qsTr("Search...")
                    rightIcon: "cil-search"
                }


        }

        ReceiptDialog{
            id: receiptDialog

            function openDialog(){
                receiptData=model.jsonObject(tableView.selectedRow)
                open();
            }

        }
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: OrdersModel{
                id: model

                onUpdateDeliveryStatusResponse: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                }

                onReturnOrderResponse: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                }

                onReturnableItemsResponse: {
                    console.log(JSON.stringify(reply))
                    var dialog=Utils.createObject("qrc:/pages/orders/OrderReturnDialog.qml",
                                                  tableView,{order: reply.order});
                    dialog.accepted.connect(function(orderId, items){model.returnOrder(orderId,items)});
                    dialog.open();
                }
            }

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{ roleValue: "OrderStatus"; OrderStatusDelegate{}}
                DelegateChoice{ roleValue: "percentage"; SuffixDelegate{suffix: "%"}}

            }

            actions: [
                Action{enabled:tableView.selectedRow>=0; text: "Details"; icon.name: "cil-info"; onTriggered: {
                        var dialog=Utils.createObject("qrc:/pages/orders/OrderDetails.qml",
                                                      tableView,{order: model.jsonObject(tableView.selectedRow)});
                        dialog.open();
                    } },

                Action{enabled:tableView.selectedRow>=0; text: "Update Status"; icon.name: "cil-reload"; onTriggered: {
                        deliveryStatusDialog.open();


                    } },
                Action{enabled:tableView.selectedRow>=0; text: "Return"; icon.name: "cil-action-undo"; onTriggered: {
                        var order =model.jsonObject(tableView.selectedRow);
                        model.returnableItems(order.id);
                    }},
                Action{enabled:tableView.selectedRow>=0; text: qsTr("Print"); icon.name: "cil-print"; onTriggered: receiptDialog.openDialog()}
            ]
        }

    }
}
