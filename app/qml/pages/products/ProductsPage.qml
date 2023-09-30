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

AppPage {
    title: qsTr("Products")
    StackView.onActivated: model.refresh()

    ColumnLayout {
        id: page
        anchors.fill: parent
        spacing: 10
        AppToolBar {
            id: toolBar
            view: tableView
            onSearch: searchString => {
                          var filter = model.filter
                          filter['query'] = searchString
                          model.filter = filter
                          model.requestData()
                      }

            advancedFilter: [{
                    "type": "text",
                    "label": qsTr("Barcode"),
                    "key": "barcode",
                    "dynamic": false,
                    "category": null,
                    "options": {
                        "placeholderText": "All..."
                    }
                }, {
                    "type": "combo",
                    "label": qsTr("Category"),
                    "key": "category_id",
                    "dynamic": false,
                    "category": null,
                    "options": {
                        "editable": true,
                        "defaultEntry": {
                            "name": qsTr("All Categories"),
                            "id": null
                        },
                        "textRole": "name",
                        "valueRole": "id",
                        "dataUrl": "/categories"
                    }
                },
                {
                    "type": "check",
                    "label": "",
                    "inner_label": qsTr("Only Variants"),
                    "key": "only_variants",
                    "dynamic": false,
                    "category": null
                }, {
                    "type": "check",
                    "label": "",
                    "inner_label": qsTr("In stock"),
                    "key": "in_stock",
                    "dynamic": false,
                    "category": null
                }]

            onFilterClicked: filter => {
                                 console.log(
                                     "filter: " + JSON.stringify(filter))
                                 model.filter = filter
                                 model.requestData()
                             }

            ProductsAttributesAttributesModel {

                onDataRecevied: {
                    for (var i = 0; i < rowCount(); i++) {
                        //                        console.log(JSON.stringify(jsonObject(i)));
                        let attribute = jsonObject(i)
                        if (!attribute['filter_visible'])
                            continue

                        let id = attribute['id']
                        let name = attribute['name']
                        let values = attribute['values']

                        toolBar.advancedFilter.push({
                                                        "type": "combo",
                                                        "label": name,
                                                        "key": id,
                                                        "dynamic": true,
                                                        "category": "attributes",
                                                        "options": {
                                                            "checkable": true,
                                                            "editable": true,
                                                            "defaultEntry": {
                                                                "value": "All",
                                                                "id": null
                                                            },
                                                            "textRole": "value",
                                                            "valueRole": "id",
                                                            "values": values
                                                        }
                                                    })
                    }
                    toolBar.advancedFilterChanged()
                }
            }
        }

        FileDialog {
            id: fileDialog
            currentFolder: StandardPaths.writableLocation(
                               StandardPaths.DocumentsLocation)
            nameFilters: ["CSV files (*.csv)", "All files (*)"]
            onAccepted: {
                Api.bulckStockAdjustment(selectedFile)
            }
        }

        AdjustStockDialog {
            id: adjustStockDlg
            onAccepted: (productId, quantity, reason) => {
                            Api.adjustStock(productId, quantity, reason)
                            adjustStockDlg.close()
                        }
        }

        Connections {
            target: Api

            function onAdjustStockReply(reply) {
                if (reply.status === 200) {
                    toastrService.push("Success", reply.message,
                                       "success", 2000)
                    model.refresh()
                } else {
                    toastrService.push("Error", reply.message, "error", 2000)
                }
            } //slot end

            function onUpdateProductReply(reply) {
                if (reply.status === 200) {
                    toastrService.push("Success", reply.message,
                                       "success", 2000)
                    model.requestData()
                } else {
                    toastrService.push("Error", reply.message, "error", 2000)
                }
            } //slot end
        }

        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser {}
            permissionProvider: function (permission) {
                return AuthManager.hasPermission(permission)
            }
            actions: [

                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate(
                                     "qrc:/PosFe/qml/pages/products/ProductForm.qml",
                                     {

                                         "title": qsTr("Add")
                                     })
                    permission: "prm_add_products"
                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate(
                                     "qrc:/PosFe/qml/pages/products/ProductForm.qml",
                                     {

                                         "title": qsTr("Edit"),
                                         "keyValue": model.jsonObject(
                                                              tableView.currentRow).id
                                     })
                    enabled: tableView.currentRow >= 0
                    permission: "prm_edit_products"
                },
                //Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeProduct()}
                CAction {
                    text: qsTr("Purchase Stock")
                    icon.name: "cil-cart"
                    onTriggered: tableView.openPurchaseDialog()
                    enabled: tableView.currentRow >= 0
                    permission: "prm_purchase_stock"
                },
                CAction {
                    text: qsTr("Adjust Stock")
                    icon.name: "cil-cart"
                    onTriggered: tableView.openAdjustStockDialog()
                    enabled: tableView.currentRow >= 0
                    permission: "prm_adjust_stock"
                },
                CAction {
                    text: qsTr("Generate Catalogue")
                    icon.name: "cil-image"
                    onTriggered: Api.generateImages()
                },
                CAction {
                    text: qsTr("Bulck Stock Adjustment")
                    icon.name: "cil-cart"
                    onTriggered: fileDialog.open()
                    permission: "prm_adjust_stock"
                }
            ]

            function openPurchaseDialog() {
                purchaseDialog.product = model.jsonObject(tableView.currentRow)
                purchaseDialog.open()
            }

            function openAdjustStockDialog() {
                adjustStockDlg.productId = model.data(tableView.currentRow,
                                                      "id")
                adjustStockDlg.originalQty = model.data(tableView.currentRow,
                                                        "products_stocks.qty")
                adjustStockDlg.open()
            }

            ProductPurchaseStockDialog {
                id: purchaseDialog

                onAccepted: {
                    var productId = model.data(tableView.currentRow, "id")
                    model.purchaseStock(productId, quantity, vendorId)
                    purchaseDialog.close()
                }
            }

            model: ProductsModel {
                id: model

                //filter: {"parent_id":0}
                //                filter: {"only_variants":true}
                //                filter: {}
                //onFilterChanged: console.log(JSON.stringify(filter))
                onProductRemoveReply: (reply) => {
                    if (reply.status === 200) {
                        model.requestData()
                    }
                } //slot end

                onStockPurchasedReply: (reply) => {
                    if (reply.status === 200) {
                        model.requestData()
                    }
                }


                //                onDataRecevied: {
                //                    model.exportJson();
                //                }
            } //model

            function removeProduct() {
                var productId = model.data(tableView.currentRow, "id")
                model.removeProduct(productId)
            }
        }
    }
}
