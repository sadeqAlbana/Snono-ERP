import QtQuick
import QtQuick.Controls.Basic
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
import CoreUI
import CoreUI.Palettes

AppPage {
    title: qsTr("Orders")

    //    background: Rectangle{color:"red";}


    function createDeliveryManifest(orderId) {
        Router.navigate("qrc:/PosFe/qml/pages/orders/DeliveryOrderForm.qml", {
                            "keyValue": orderId
                        })

    }

    AppDialog {
        id: newDeliveryManifestDlg
        property var orderId
        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Warning")
            padding: 25
            ColumnLayout {
                anchors.fill: parent
                Label {
                    text: qsTr("Order already have delivery manifest, do you want to overrite it?")
                    font.pixelSize: 24
                }
            }

            footer: RowLayout {
                HorizontalSpacer {}
                CButton {
                    palette: BrandDanger {}
                    text: qsTr("Cancel")
                    Layout.margins: 15
                    onClicked: close()
                }

                CButton {
                    palette: BrandInfo {}
                    text: qsTr("Ok")
                    Layout.margins: 15
                    onClicked: {
                        createDeliveryManifest(
                                                           newDeliveryManifestDlg.orderId);
                        newDeliveryManifestDlg.close();
                    }
                }
            }
        } //card
    }

    ColumnLayout {
        id: page
        //tableView.actions
        anchors.fill: parent
        UpdateDeliveryStatusDialog {
            id: deliveryStatusDialog
            onAccepted: {
                model.updateDeliveryStatus(model.jsonObject(
                                               tableView.currentRow).id, status)
            }
        }
        ReceiptDialog {
            id: receiptDialog

            function openDialog() {
                receiptData = model.jsonObject(tableView.currentRow)
                open()
            }
        }

        AppToolBar {
            id: toolBar
            view: tableView
            advancedFilter: [{
                    "type": "text",
                    "label": qsTr("Customer Name"),
                    "key": "customer_name",
                    "options": {
                        "placeholderText": qsTr("All...")
                    }
                }, {
                    "type": "text",
                    "label": qsTr("Customer Phone"),
                    "key": "customer_phone",
                    "options": {
                        "placeholderText": qsTr("All...")
                    }
                }, {
                    "type": "text",
                    "label": qsTr("Customer Address"),
                    "key": "customer_address",
                    "options": {
                        "placeholderText": qsTr("All...")
                    }
                },
                {
                    "type": "combo",
                    "label": qsTr("product"),
                    "key": "products",
                    "options": {
                        "checkable": false,
                        "editable": true,
                        "defaultEntry": {
                            "name": qsTr("All Products"),
                            "id": null
                        },
                        "textRole": "name",
                        "valueRole": "id",
                        "dataUrl": "/products/list",
                        "filter": {
                            "onlyVariants": true
                        }
                    }
                }, {
                    "type": "date",
                    "label": qsTr("from"),
                    "key": "from"
                }, {
                    "type": "date",
                    "label": qsTr("to"),
                    "key": "to"
                }, {
                    "type": "checkableCombo",
                    "label": qsTr("status"),
                    "key": "status",
                    "options": {
                        "checkable": true,
                        "editable": true,
                        "textRole": "name",
                        "valueRole": "value",
                        "dataUrl": "/orders/status/list"
                    }
                }]
            onSearch: searchString => {
                          var filter = model.filter
                          filter['query'] = searchString
                          model.filter = filter
                          model.requestData()
                      }

            onFilterClicked: filter => {
                                 model.filter = filter
                                 model.requestData()
                             }
        } //toolbar

        //        AppDialog{
        //            id: newDeliveryManifestDlg
        //        }
        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: OrdersModel {
                id: model
                onUpdateDeliveryStatusResponse: reply => {
                                                    if (reply.status === 200) {
                                                        model.requestData()
                                                    }
                                                }
            }

            delegate: AppDelegateChooser {
                DelegateChoice {
                    roleValue: "OrderStatus"
                    OrderStatusDelegate {}
                }
                DelegateChoice {
                    roleValue: "externalDeliveryStatus"
                    ExternalDeliveryStatusDelegate {}
                }
            }

            actions: [
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Details")
                    icon.name: "cil-notes"
                    onTriggered: {
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/orders/OrderDetailsPage.qml",
                                    {
                                        "keyValue": model.jsonObject(
                                                        tableView.currentRow).id
                                    })
                    }
                },

                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Update Status")
                    icon.name: "cil-reload"
                    onTriggered: {
                        deliveryStatusDialog.open()
                    }
                },
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Return")
                    icon.name: "cil-action-undo"
                    onTriggered: {
                        let order = model.jsonObject(tableView.currentRow)
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/orders/ReturnOrderPage.qml",
                                    {
                                        "order": order
                                    })
                    }
                },

                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Create Delivery Order")
                    icon.name: "cil-plus-circle"
                    onTriggered: {
                        let order = model.jsonObject(tableView.currentRow)
                        if (order.external_delivery_id!==undefined) {
                            newDeliveryManifestDlg.orderId = order.id
                            newDeliveryManifestDlg.open()
                        } else {
                            createDeliveryManifest(order.id)
                        }
                    }
                },

                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Print")
                    icon.name: "cil-print"
                    onTriggered: receiptDialog.openDialog()
                },
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Print Delivery Receipt")
                    icon.name: "cil-print"
                    onTriggered: {
                        let reference = model.data(tableView.currentRow, "id")
                        Api.barqReceipt(reference)
                    }
                },
                CAction {
                    text: qsTr("Print Report")
                    icon.name: "cil-print"
                    onTriggered: model.print()
                }
            ]
        }
    }
}
