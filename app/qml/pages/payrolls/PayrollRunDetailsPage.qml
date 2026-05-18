import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
import CoreUI
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import CoreUI.Notifications
import CoreUI.Impl
import PosFe
import CoreUI.Palettes
AppPage {
    id: page
    title: qsTr("Payroll Run")

    property int runId: -1
    property var run: ({})
    property var items: []
    property var employees: []
    readonly property bool isDraft: page.run?.status === "draft"
    readonly property bool isPosted: page.run?.status === "posted"

    function reload() {
        if (page.runId <= 0) return;
        Api.fetchPayrollRun(page.runId).subscribe(function(res){
            var json = res.json();
            if (json.status === 200) {
                page.run = json.data ?? {};
                page.items = page.run.items ?? [];
            } else {
                toastrService.push(qsTr("Error"), json.message ?? "", "danger", 4000);
            }
        });
    }

    function loadEmployees() {
        Api.fetchEmployees().subscribe(function(res){
            page.employees = res.json("data") ?? [];
        });
    }

    Component.onCompleted: { reload(); loadEmployees(); }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        GridLayout {
            columns: 6
            Layout.fillWidth: true
            CLabel { text: qsTr("ID") }
            CTextField { readOnly: true; text: page.run?.id ?? ""; Layout.fillWidth: true }
            CLabel { text: qsTr("Name") }
            CTextField { readOnly: true; text: page.run?.name ?? ""; Layout.fillWidth: true }
            CLabel { text: qsTr("Status") }
            CTextField { readOnly: true; text: page.run?.status ?? ""; Layout.fillWidth: true }

            CLabel { text: qsTr("Period Start") }
            CTextField { readOnly: true; text: page.run?.period_start ?? ""; Layout.fillWidth: true }
            CLabel { text: qsTr("Period End") }
            CTextField { readOnly: true; text: page.run?.period_end ?? ""; Layout.fillWidth: true }
            CLabel { text: qsTr("Total") }
            CTextField { readOnly: true; text: page.run?.total ?? ""; Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            CLabel { text: qsTr("Items"); font.pixelSize: 18 }
            HorizontalSpacer {}
            CButton {
                text: qsTr("Add Item")
                icon.name: "cil-plus"
                palette: BrandPrimary {}
                enabled: page.isDraft && AuthManager.hasPermission("prm_add_payroll")
                onClicked: { itemDialog.openForAdd(); }
            }
            CButton {
                text: qsTr("Post")
                icon.name: "cil-check"
                palette: BrandSuccess {}
                enabled: page.isDraft && page.items.length > 0 && AuthManager.hasPermission("prm_post_payroll")
                onClicked: {
                    Api.postPayrollRun(page.runId).subscribe(function(res){
                        var j = res.json();
                        toastrService.push(j.status === 200 ? qsTr("Posted") : qsTr("Error"),
                                           j.message ?? "",
                                           j.status === 200 ? "success" : "danger", 4000);
                        page.reload();
                    });
                }
            }
            CButton {
                text: qsTr("Pay All")
                icon.name: "cil-dollar"
                palette: BrandSuccess {}
                enabled: page.isPosted && AuthManager.hasPermission("prm_pay_payroll")
                onClicked: {
                    Api.payPayrollRun(page.runId).subscribe(function(res){
                        var j = res.json();
                        toastrService.push(j.status === 200 ? qsTr("Paid") : qsTr("Error"),
                                           j.message ?? "",
                                           j.status === 200 ? "success" : "danger", 4000);
                        page.reload();
                    });
                }
            }
        }

        ListView {
            id: itemsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: page.items
            clip: true
            spacing: 4
            delegate: Rectangle {
                width: itemsView.width
                height: 50
                color: index % 2 === 0 ? "#fafafa" : "#ffffff"
                border.color: "#e0e0e0"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 12
                    Label { text: "#" + (modelData.id ?? ""); Layout.preferredWidth: 60 }
                    Label {
                        text: (modelData.employee?.name) ?? ("Employee " + (modelData.employee_id ?? ""))
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Label { text: qsTr("Net: ") + (modelData.net_amount ?? ""); Layout.preferredWidth: 140 }
                    Label {
                        text: modelData.payment_journal_entry_id ? qsTr("Paid") : qsTr("Unpaid")
                        color: modelData.payment_journal_entry_id ? "green" : "#999"
                        Layout.preferredWidth: 70
                    }
                    CButton {
                        text: qsTr("Edit")
                        palette: BrandInfo {}
                        visible: page.isDraft
                        enabled: AuthManager.hasPermission("prm_edit_payroll")
                        onClicked: itemDialog.openForEdit(modelData)
                    }
                    CButton {
                        text: qsTr("Remove")
                        palette: BrandDanger {}
                        visible: page.isDraft
                        enabled: AuthManager.hasPermission("prm_remove_payroll")
                        onClicked: {
                            Api.removePayrollItem(modelData.id).subscribe(function(res){
                                if (res.json().status === 200) page.reload();
                            });
                        }
                    }
                    CButton {
                        text: qsTr("Pay")
                        palette: BrandSuccess {}
                        visible: page.isPosted && !modelData.payment_journal_entry_id
                        enabled: AuthManager.hasPermission("prm_pay_payroll")
                        onClicked: {
                            Api.payPayrollItem(modelData.id).subscribe(function(res){
                                if (res.json().status === 200) page.reload();
                            });
                        }
                    }
                }
            }
        }
    }

    AppDialog {
        id: itemDialog
        property int editingItemId: -1
        function openForAdd() {
            editingItemId = -1;
            employeeCB.currentIndex = -1;
            netAmountLE.text = "0";
            open();
        }
        function openForEdit(item) {
            editingItemId = item.id;
            netAmountLE.text = String(item.net_amount);
            open();
        }

        Card {
            anchors.fill: parent
            header.visible: true
            title: itemDialog.editingItemId > 0 ? qsTr("Edit Item") : qsTr("Add Item")
            padding: 20
            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 15

                CLabel { text: qsTr("Employee") }
                CComboBox {
                    id: employeeCB
                    Layout.fillWidth: true
                    enabled: itemDialog.editingItemId <= 0
                    model: page.employees
                    textRole: "name"
                    valueRole: "id"
                }

                CLabel { text: qsTr("Net Amount") }
                CIconTextField {
                    id: netAmountLE
                    leftIcon.name: "cil-dollar"
                    Layout.fillWidth: true
                    validator: DoubleValidator { bottom: 0 }
                }
            }
            footer: RowLayout {
                HorizontalSpacer {}
                CButton {
                    palette: BrandDanger {}
                    text: qsTr("Cancel")
                    Layout.margins: 10
                    onClicked: itemDialog.close()
                }
                CButton {
                    text: qsTr("Save")
                    palette: BrandPrimary {}
                    Layout.margins: 10
                    onClicked: {
                        var amount = parseFloat(netAmountLE.text);
                        if (isNaN(amount) || amount <= 0) {
                            toastrService.push(qsTr("Error"), qsTr("Net amount must be > 0"), "danger", 4000);
                            return;
                        }
                        var cb;
                        if (itemDialog.editingItemId > 0) {
                            cb = Api.updatePayrollItem(itemDialog.editingItemId, amount);
                        } else {
                            if (employeeCB.currentIndex < 0) {
                                toastrService.push(qsTr("Error"), qsTr("Pick an employee"), "danger", 4000);
                                return;
                            }
                            cb = Api.addPayrollItem(page.runId, employeeCB.currentValue, amount);
                        }
                        cb.subscribe(function(res){
                            var j = res.json();
                            if (j.status === 200) {
                                itemDialog.close();
                                page.reload();
                            } else {
                                toastrService.push(qsTr("Error"), j.message ?? "", "danger", 4000);
                            }
                        });
                    }
                }
            }
        }
    }
}
