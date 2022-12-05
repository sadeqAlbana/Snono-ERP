import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage{
    title: qsTr("Orders")
    padding: 10
//    background: Rectangle{color:"red";}
    ColumnLayout{
        id: page
        //tableView.actions
        anchors.fill: parent;
        UpdateDeliveryStatusDialog{
            id: deliveryStatusDialog;
            onAccepted: {
                model.updateDeliveryStatus(model.jsonObject(tableView.selectedRow).id,status);
            }
        }
        ReceiptDialog{
            id: receiptDialog

            function openDialog(){
                receiptData=model.jsonObject(tableView.selectedRow)
                open();
            }
        }

        AppToolBar{
            id: toolBar
            tableView: tableView
            advancedFilter:  [
                {"type": "text","label": "Customer Name","key": "customer_name","options":{"placeholderText":"All..."}},
                {"type": "text","label": "Customer Phone","key": "customer_phone","options":{"placeholderText":"All..."}},
                {"type": "text","label": "Customer Address","key": "customer_address","options":{"placeholderText":"All..."}},

                {"type": "combo","label": "product","key": "products",
                    "options":{"checkable": true,"editable":true,"defaultEntry":{"name":"All Products","id":null},"textRole": "name", "valueRole": "id","dataUrl": "/products/list",
                        "filter":{"onlyVariants":true}}},
                {"type": "date","label": "from","key": "from"},
                {"type": "date","label": "to","key": "to"}

            ]
            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

            onFilterClicked: (filter) => {
                                 model.filter=filter
                                 model.requestData();
                             }

        }//toolbar

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: OrdersModel{
                id: model
                onUpdateDeliveryStatusResponse:(reply)=> {
                    if(reply.status===200){
                        model.requestData();
                    }
                }
                onReturnOrderResponse:(reply)=> {
                    if(reply.status===200){
                        model.requestData();
                    }
                }

                onReturnableItemsResponse:(reply)=> {
                    var dialog=Utils.createObject("qrc:/PosFe/qml/pages/orders/OrderReturnDialog.qml",
                                                  tableView,{order: reply.order});
                    dialog.accepted.connect(function(orderId, items){model.returnOrder(orderId,items)});
                    dialog.open();
                }
            }


            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "OrderStatus"; OrderStatusDelegate{}}
                DelegateChoice{ roleValue: "externalDeliveryStatus"; ExternalDeliveryStatusDelegate{}}

            }

            actions: [
                CAction{enabled:tableView.selectedRow>=0; text: qsTr("Details"); icon.name: "cil-notes"; onTriggered: {
                        var dialog=Utils.createObject("qrc:/PosFe/qml/pages/orders/OrderDetails.qml",
                                                      tableView,{order: model.jsonObject(tableView.selectedRow)});
                        dialog.open();
                    } },

                CAction{enabled:tableView.selectedRow>=0; text: qsTr("Update Status"); icon.name: "cil-reload"; onTriggered: {
                        deliveryStatusDialog.open();
                    } },
                CAction{enabled:tableView.selectedRow>=0; text: qsTr("Return"); icon.name: "cil-action-undo"; onTriggered: {
                        var order =model.jsonObject(tableView.selectedRow);
                        model.returnableItems(order.id);
                    }},
                CAction{enabled:tableView.selectedRow>=0; text: qsTr("Print"); icon.name: "cil-print"; onTriggered: receiptDialog.openDialog()},
                CAction{enabled:tableView.selectedRow>=0; text: qsTr("Print Delivery Receipt"); icon.name: "cil-print"; onTriggered: {
                    let reference=model.data(tableView.selectedRow,"id")
                        Api.barqReceipt(reference);
                    }}

            ]
        }

    }
}