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
import CoreUI.Palettes
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage {
    id: page
    title: qsTr("Payroll Run")

    property int runId: -1
    property var run: ({})
    property var items: []
    property var employees: []
    property var titlesById: ({})
    readonly property bool isDraft: page.run?.status === "draft"
    readonly property bool isPosted: page.run?.status === "posted"

    function titleName(id) {
        if (!id) return qsTr("(no title)");
        var t = page.titlesById[id];
        return t ? t.name : ("Title #" + id);
    }

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

    function loadTitles() {
        NetworkManager.post("/jobTitles/list", {}).subscribe(function(res){
            var rows = res.json("data") ?? [];
            var map = ({});
            for (var i = 0; i < rows.length; i++) map[rows[i].id] = rows[i];
            page.titlesById = map;
        });
    }

    Component.onCompleted: { reload(); loadEmployees(); loadTitles(); }

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
            CTextField { readOnly: true; text: Utils.formatCurrency(page.run?.total ?? 0); Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            CLabel { text: qsTr("Items"); font.pixelSize: 18 }
            HorizontalSpacer {}
            CButton {
                text: qsTr("Add Employee")
                icon.name: "cil-plus"
                palette: BrandPrimary {}
                enabled: page.isDraft && AuthManager.hasPermission("prm_add_payroll")
                onClicked: addEmployeeDialog.openDialog()
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
                    Label {
                        text: page.titleName(modelData.job_title_id)
                        color: "#666"
                        Layout.preferredWidth: 180
                        elide: Text.ElideRight
                    }
                    Label { text: qsTr("Net: ") + Utils.formatCurrency(modelData.net_amount ?? 0); Layout.preferredWidth: 160 }
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
                        onClicked: editItemDialog.openForEdit(modelData)
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

    // --- Single-item edit dialog (amount only) ---
    AppDialog {
        id: editItemDialog
        property int editingItemId: -1
        function openForEdit(item) {
            editingItemId = item.id;
            editAmountLE.text = String(item.net_amount);
            open();
        }
        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Edit Item Amount")
            padding: 20
            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 15
                CLabel { text: qsTr("Net Amount") }
                CIconTextField {
                    id: editAmountLE
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
                    onClicked: editItemDialog.close()
                }
                CButton {
                    text: qsTr("Save")
                    palette: BrandPrimary {}
                    Layout.margins: 10
                    onClicked: {
                        var amount = parseFloat(editAmountLE.text);
                        if (isNaN(amount) || amount <= 0) {
                            toastrService.push(qsTr("Error"), qsTr("Net amount must be > 0"), "danger", 4000);
                            return;
                        }
                        Api.updatePayrollItem(editItemDialog.editingItemId, amount).subscribe(function(res){
                            var j = res.json();
                            if (j.status === 200) {
                                editItemDialog.close();
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

    // --- Add-employee dialog (creates one item per assigned title) ---
    AppDialog {
        id: addEmployeeDialog
        property var draftLines: []   // [{job_title_id, name, net_amount}]

        function openDialog() {
            draftLines = [];
            empCB.currentIndex = -1;
            open();
        }

        function loadEmployeeTitles() {
            if (empCB.currentIndex < 0) { draftLines = []; return; }
            var partyId = empCB.currentValue;
            Api.fetchPartyJobTitles(partyId).subscribe(function(res){
                var titles = res.json() ?? [];
                if (titles.length === 0) {
                    draftLines = [{
                        "job_title_id": null,
                        "name": qsTr("(no title)"),
                        "net_amount": 0
                    }];
                } else {
                    var lines = [];
                    for (var i = 0; i < titles.length; i++) {
                        lines.push({
                            "job_title_id": titles[i].id,
                            "name": titles[i].name,
                            "net_amount": titles[i].default_salary
                        });
                    }
                    draftLines = lines;
                }
            });
        }

        function setLineAmount(idx, val) {
            var copy = draftLines.slice();
            copy[idx].net_amount = val;
            draftLines = copy;
        }

        function removeLine(idx) {
            var copy = draftLines.slice();
            copy.splice(idx, 1);
            draftLines = copy;
        }

        function totalDraft() {
            var t = 0;
            for (var i = 0; i < draftLines.length; i++) {
                t += parseFloat(draftLines[i].net_amount) || 0;
            }
            return t;
        }

        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Add Employee to Payroll")
            padding: 15
            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                GridLayout {
                    columns: 2
                    Layout.fillWidth: true
                    columnSpacing: 12
                    CLabel { text: qsTr("Employee") }
                    CComboBox {
                        id: empCB
                        Layout.fillWidth: true
                        model: page.employees
                        textRole: "name"
                        valueRole: "id"
                        onCurrentValueChanged: addEmployeeDialog.loadEmployeeTitles()
                    }
                }

                Label {
                    visible: empCB.currentIndex >= 0
                    text: qsTr("One payroll line per assigned job title (amounts editable):")
                    color: "#666"
                }

                ListView {
                    id: linesView
                    visible: empCB.currentIndex >= 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 250
                    model: addEmployeeDialog.draftLines
                    clip: true
                    spacing: 4
                    delegate: Rectangle {
                        width: linesView.width
                        height: 44
                        color: index % 2 === 0 ? "#fafafa" : "#ffffff"
                        border.color: "#e0e0e0"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            Label {
                                text: modelData.name
                                Layout.preferredWidth: 220
                                elide: Text.ElideRight
                            }
                            CIconTextField {
                                Layout.fillWidth: true
                                leftIcon.name: "cil-dollar"
                                text: String(modelData.net_amount ?? 0)
                                validator: DoubleValidator { bottom: 0 }
                                onTextChanged: addEmployeeDialog.setLineAmount(index, parseFloat(text) || 0)
                            }
                            CButton {
                                text: qsTr("X")
                                palette: BrandDanger {}
                                onClicked: addEmployeeDialog.removeLine(index)
                            }
                        }
                    }
                }

                Label {
                    visible: empCB.currentIndex >= 0
                    text: qsTr("Total: ") + Utils.formatCurrency(addEmployeeDialog.totalDraft())
                    font.bold: true
                }
            }
            footer: RowLayout {
                HorizontalSpacer {}
                CButton {
                    palette: BrandDanger {}
                    text: qsTr("Cancel")
                    Layout.margins: 10
                    onClicked: addEmployeeDialog.close()
                }
                CButton {
                    text: qsTr("Save")
                    palette: BrandPrimary {}
                    Layout.margins: 10
                    onClicked: {
                        if (empCB.currentIndex < 0) {
                            toastrService.push(qsTr("Error"), qsTr("Pick an employee"), "danger", 3000);
                            return;
                        }
                        if (addEmployeeDialog.draftLines.length === 0) {
                            toastrService.push(qsTr("Error"), qsTr("No lines to add"), "danger", 3000);
                            return;
                        }
                        var payload = [];
                        for (var i = 0; i < addEmployeeDialog.draftLines.length; i++) {
                            var l = addEmployeeDialog.draftLines[i];
                            payload.push({
                                "job_title_id": l.job_title_id,
                                "net_amount": parseFloat(l.net_amount) || 0
                            });
                        }
                        Api.addEmployeeToPayroll(page.runId, empCB.currentValue, payload)
                           .subscribe(function(res){
                            var j = res.json();
                            if (j.status === 200) {
                                addEmployeeDialog.close();
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
