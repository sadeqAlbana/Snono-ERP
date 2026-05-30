import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import PosFe
import CoreUI
import CoreUI.Forms
import CoreUI.Base
import CoreUI.Views
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Notifications
import "qrc:/PosFe/qml/screens/utils.js" as Utils

// Create a carrier settlement: pick a carrier (+ driver for the internal
// carrier), review the carrier's delivered-but-unsettled shipments and the
// total owed, then submit the selected shipment ids to the settlement endpoint.
Card {
    id: page
    title: qsTr("Create Settlement")
    property var keyValue: null

    property var carriers: []
    property var drivers: []
    property int carrierId: -1
    property string carrierName: ""
    property int driverId: -1
    property var shipments: []
    property var selectedIds: []

    // the internal carrier is the only one settled per-driver; for it a driver
    // must be chosen so every shipment in the batch shares the same driver.
    readonly property bool isInternal: carrierName === "Internal Carrier"

    function isSelected(id) { return selectedIds.indexOf(id) >= 0; }
    function toggle(id, on) {
        var arr = selectedIds.slice();
        var i = arr.indexOf(id);
        if (on && i < 0) arr.push(id);
        else if (!on && i >= 0) arr.splice(i, 1);
        selectedIds = arr;
    }
    function selectedTotal() {
        var t = 0;
        for (var i = 0; i < shipments.length; i++)
            if (isSelected(shipments[i].id)) t += (shipments[i].paid_cod || 0);
        return t;
    }

    function loadShipments() {
        shipments = [];
        selectedIds = [];
        if (carrierId < 0) return;
        if (isInternal && driverId < 0) return;
        var filter = {
            "carrier_ids": [carrierId],
            "statuses": ["delivered", "returned", "partially_returned", "cancelled"],
            "settled": 0
        };
        if (isInternal) filter["driver_ids"] = [driverId];
        NetworkManager.post("/shipments", { "filter": filter }).subscribe(function(res) {
            var rows = res.json("data") || [];
            page.shipments = rows;
            var ids = [];
            for (var i = 0; i < rows.length; i++) ids.push(rows[i].id); // pre-select all
            page.selectedIds = ids;
        });
    }

    function submit() {
        if (selectedIds.length === 0) {
            toastrService.push(qsTr("Nothing selected"), qsTr("Select at least one shipment."), "warning", 3000);
            return;
        }
        NetworkManager.post("/shipments/carriers/settlement/create",
                            { "shipments_ids": selectedIds }).subscribe(function(res) {
            var j = res.json();
            if (j.status === 200) {
                toastrService.push(qsTr("Settled"),
                                   qsTr("Settlement created (net %1).").arg(
                                       Utils.formatCurrency((j.settlement && j.settlement.net_total) || selectedTotal())),
                                   "success", 4000);
                Router.back();
            } else {
                toastrService.push(qsTr("Settlement failed"), j.message || qsTr("Error"), "danger", 5000);
            }
        });
    }

    Component.onCompleted: {
        NetworkManager.get("/shipments/carriers/list").subscribe(function(res) {
            page.carriers = res.json("data") || [];
        });
        NetworkManager.post("/driver/list", {}).subscribe(function(res) {
            page.drivers = res.json("data") || [];
        });
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 10
            Layout.fillWidth: true

            CLabel { text: qsTr("Carrier") }
            CComboBox {
                id: carrierCombo
                Layout.fillWidth: true
                model: page.carriers
                valueRole: "id"
                textRole: "name"
                onActivated: {
                    page.carrierId = currentValue;
                    page.carrierName = currentText;
                    page.driverId = -1;
                    driverCombo.currentIndex = -1;
                    page.loadShipments();
                }
            }

            CLabel { text: qsTr("Driver"); visible: page.isInternal }
            CComboBox {
                id: driverCombo
                visible: page.isInternal
                Layout.fillWidth: true
                model: page.drivers
                valueRole: "id"
                textRole: "first_name"
                onActivated: {
                    page.driverId = currentValue;
                    page.loadShipments();
                }
            }
        }

        CLabel {
            visible: page.isInternal && page.driverId < 0
            text: qsTr("Select a driver to list their unsettled shipments.")
            color: "#888"
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            model: page.shipments
            delegate: Rectangle {
                width: list.width
                height: 52
                color: index % 2 === 0 ? "#fafafa" : "#ffffff"
                border.color: "#e0e0e0"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10
                    CheckBox {
                        checked: page.isSelected(modelData.id)
                        onToggled: page.toggle(modelData.id, checked)
                    }
                    Label {
                        text: "#" + modelData.id
                        font.bold: true
                        Layout.preferredWidth: 50
                    }
                    Label {
                        text: modelData.status
                        Layout.preferredWidth: 140
                        color: "#666"
                    }
                    Label {
                        text: (modelData.dst_address ? modelData.dst_address.first_name : "")
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Label {
                        text: Utils.formatCurrency(modelData.paid_cod || 0)
                        font.bold: true
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: qsTr("Selected: %1").arg(page.selectedIds.length)
                color: "#666"
            }
            HorizontalSpacer {}
            Label {
                text: qsTr("Total COD: ") + Utils.formatCurrency(page.selectedTotal())
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
                text: qsTr("Create Settlement")
                palette: BrandSuccess {}
                enabled: page.selectedIds.length > 0
                onClicked: page.submit()
            }
        }
    }
}
