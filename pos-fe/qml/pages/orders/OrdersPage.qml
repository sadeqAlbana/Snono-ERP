import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import App.Models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

Card{
    title: qsTr("Orders")
    padding: 10
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

                {"type": "combo","label": "product","key": "product_id",
                    "options":{"defaultEntry":{"name":"All Products","id":null},"textRole": "name", "valueRole": "id","dataUrl": "/products/list",
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

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: OrdersModel{
                id: model
                onUpdateDeliveryStatusResponse: {
                    if(reply.status===200){
                        model.requestData();
                    }
                }
                onReturnOrderResponse: {
                    if(reply.status===200){
                        model.requestData();
                    }
                }

                onReturnableItemsResponse: {
                    var dialog=Utils.createObject("qrc:/pages/orders/OrderReturnDialog.qml",
                                                  tableView,{order: reply.order});
                    dialog.accepted.connect(function(orderId, items){model.returnOrder(orderId,items)});
                    dialog.open();
                }
            }

            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "OrderStatus"; OrderStatusDelegate{}}
            }

            actions: [
                Action{enabled:tableView.selectedRow>=0; text: "Details"; icon.name: "cil-notes"; onTriggered: {
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
                Action{enabled:tableView.selectedRow>=0; text: qsTr("Print"); icon.name: "cil-print"; onTriggered: receiptDialog.openDialog()},
                Action{enabled:tableView.selectedRow>=0; text: qsTr("Print Delivery Receipt"); icon.name: "cil-print"; onTriggered: {
                    let reference=model.data(tableView.selectedRow,"reference")
                        Api.barqReceipt(reference);
                    }}

            ]
        }

    }
}
