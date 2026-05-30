import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI
import CoreUI.Palettes
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

// Internal-carrier exchange. Pick items from the original order to return (left),
// add the replacement products (right), choose who pays delivery, then submit.
// The backend reverses the returned lines (credit AR, no cash refund) and creates
// a new linked exchange order whose shipment collects only the NET at the door.
AppPage {
    id: page
    title: qsTr("Exchange Order")
    required property var order

    // returned side comes from the reusable return picker
    readonly property real returnedTotal: returnListView.returnTotal
    // replacement side is built here
    property real replacementTotal: 0
    readonly property real netGoods: replacementTotal - returnedTotal

    function recompute() {
        var t = 0;
        for (var i = 0; i < replacementModel.count; i++) {
            var r = replacementModel.get(i);
            t += (r.qty || 0) * (r.unitPrice || 0);
        }
        page.replacementTotal = t;
    }

    function submit() {
        var ret = returnListView.returnedItems();
        if (ret.length === 0) {
            toastrService.push(qsTr("Nothing to return"),
                               qsTr("Select at least one item to exchange."), "warning", 3000);
            return;
        }
        if (replacementModel.count === 0) {
            toastrService.push(qsTr("No replacement"),
                               qsTr("Add at least one replacement product."), "warning", 3000);
            return;
        }
        var newItems = [];
        for (var i = 0; i < replacementModel.count; i++) {
            var r = replacementModel.get(i);
            newItems.push({ "product_id": r.productId, "qty": r.qty,
                            "unit_price": r.unitPrice, "discount": 0 });
        }
        NetworkManager.post("/orders/exchange", {
            "order_id": page.order.id,
            "returned_items": ret,
            "new_items": newItems,
            "delivery_paid_by": deliveryPaidByCombo.currentValue
        }).subscribe(function(res) {
            var j = res.json();
            if (j.status === 200) {
                var net = j.net || 0;
                var msg = net >= 0
                    ? qsTr("Driver collects %1 (goods) + delivery at the door.").arg(Utils.formatCurrency(net))
                    : qsTr("Driver refunds %1 (goods) to the customer.").arg(Utils.formatCurrency(-net));
                toastrService.push(qsTr("Exchange created"), msg, "success", 5000);
                Router.back();
            } else {
                toastrService.push(qsTr("Exchange failed"), j.message || qsTr("Error"), "danger", 5000);
            }
        });
    }

    ListModel { id: replacementModel } // {productId, name, qty, unitPrice}

    ProductPickerDialog {
        id: productPicker
        onProductPickedObject: function(product) {
            // merge into an existing line of the same product, else append
            for (var i = 0; i < replacementModel.count; i++) {
                if (replacementModel.get(i).productId === product.id) {
                    replacementModel.setProperty(i, "qty", replacementModel.get(i).qty + 1);
                    page.recompute();
                    return;
                }
            }
            replacementModel.append({ "productId": product.id, "name": product.name,
                                      "qty": 1, "unitPrice": product.list_price });
            page.recompute();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        CLabel {
            text: qsTr("Order #%1 — %2").arg(page.order.id).arg(page.order.reference ?? "")
            font.bold: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // ---- returned items (reuse the verified return picker) ----
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6
                CLabel { text: qsTr("Items to return"); font.bold: true }
                OrderReturnListView {
                    id: returnListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    orderId: page.order.id
                }
            }

            Rectangle { Layout.fillHeight: true; width: 1; color: "#e0e0e0" }

            // ---- replacement items ----
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 0
                        CLabel { text: qsTr("Items to send"); font.bold: true }
                        CLabel {
                            text: qsTr("replacements and/or extra items the customer adds")
                            color: "#888"
                            font.pixelSize: 11
                        }
                    }
                    HorizontalSpacer {}
                    CButton {
                        text: qsTr("Add product")
                        palette: BrandSuccess {}
                        onClicked: productPicker.open()
                    }
                }
                ListView {
                    id: replacementList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 4
                    model: replacementModel
                    delegate: Rectangle {
                        width: replacementList.width
                        height: 54
                        color: index % 2 === 0 ? "#fafafa" : "#ffffff"
                        border.color: "#e0e0e0"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 8
                            CLabel {
                                text: model.name
                                Layout.preferredWidth: 180
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                            }
                            CSpinBox {
                                from: 1; to: 99999
                                value: model.qty
                                Layout.preferredWidth: 110
                                onValueModified: {
                                    replacementModel.setProperty(index, "qty", value);
                                    page.recompute();
                                }
                            }
                            CNumberInput {
                                Layout.preferredWidth: 110
                                text: String(model.unitPrice)
                                onEditingFinished: {
                                    replacementModel.setProperty(index, "unitPrice", parseFloat(text) || 0);
                                    page.recompute();
                                }
                            }
                            CLabel {
                                text: Utils.formatCurrency(model.qty * model.unitPrice)
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                font.bold: true
                            }
                            CButton {
                                text: "✕"
                                palette: BrandDanger {}
                                implicitWidth: 36
                                onClicked: { replacementModel.remove(index); page.recompute(); }
                            }
                        }
                    }
                }
            }
        }

        // ---- delivery payer + net summary ----
        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 8
            Layout.fillWidth: true

            CLabel { text: qsTr("Delivery fee paid by") }
            CComboBox {
                id: deliveryPaidByCombo
                Layout.preferredWidth: 360
                textRole: "text"
                valueRole: "value"
                currentIndex: 0
                model: [
                    { "value": "customer", "text": qsTr("Customer (added to what they pay)") },
                    { "value": "us", "text": qsTr("Us (wrong item / free delivery)") }
                ]
            }
        }

        RowLayout {
            Layout.fillWidth: true
            CLabel { text: qsTr("Returned: %1").arg(Utils.formatCurrency(page.returnedTotal)); color: "#666" }
            CLabel { text: qsTr("   Sending: %1").arg(Utils.formatCurrency(page.replacementTotal)); color: "#666" }
            HorizontalSpacer {}
            CLabel {
                text: page.netGoods >= 0
                      ? qsTr("Customer pays (goods): %1").arg(Utils.formatCurrency(page.netGoods))
                      : qsTr("Refund to customer (goods): %1").arg(Utils.formatCurrency(-page.netGoods))
                color: page.netGoods >= 0 ? "#2eb85c" : "#e55353"
                font.bold: true
                font.pixelSize: 16
            }
        }

        RowLayout {
            Layout.fillWidth: true
            CButton {
                text: qsTr("Cancel")
                palette: BrandDanger {}
                onClicked: Router.back()
            }
            HorizontalSpacer {}
            CButton {
                text: qsTr("Process Exchange")
                palette: BrandSuccess {}
                enabled: replacementModel.count > 0
                onClicked: page.submit()
            }
        }
    }
}
