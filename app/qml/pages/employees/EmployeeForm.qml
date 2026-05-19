import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI
import CoreUI.Forms
import CoreUI.Base
import CoreUI.Views
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Notifications
import CoreUI.Impl
import QtQuick.Layouts
import "qrc:/PosFe/qml/screens/utils.js" as Utils
Card {
    id: page
    title: qsTr("Employee")
    property alias initialValues: general.initialValues
    property var keyValue: null
    property bool readOnly: false

    property var allTitles: []
    property var assignedTitleIds: []

    function loadTitles() {
        NetworkManager.post("/jobTitles/list", {}).subscribe(function(res){
            page.allTitles = res.json("data") ?? [];
        });
        if (page.keyValue) {
            NetworkManager.post("/party/jobTitles", {"party_id": page.keyValue}).subscribe(function(res){
                var rows = res.json() ?? [];
                var ids = [];
                for (var i = 0; i < rows.length; i++) ids.push(rows[i].id);
                page.assignedTitleIds = ids;
            });
        }
    }
    Component.onCompleted: loadTitles()

    function isAssigned(id) {
        return page.assignedTitleIds.indexOf(id) >= 0;
    }
    function toggleAssigned(id, checked) {
        var ids = page.assignedTitleIds.slice();
        var idx = ids.indexOf(id);
        if (checked && idx < 0) ids.push(id);
        else if (!checked && idx >= 0) ids.splice(idx, 1);
        page.assignedTitleIds = ids;
    }
    function saveAssignments() {
        if (!page.keyValue) {
            toastrService.push(qsTr("Save employee first"),
                               qsTr("Create the employee record before assigning job titles."),
                               "warning", 4000);
            return;
        }
        NetworkManager.post("/party/jobTitles/set", {
            "party_id": page.keyValue,
            "title_ids": page.assignedTitleIds
        }).subscribe(function(res){
            var j = res.json();
            toastrService.push(j.status === 200 ? qsTr("Saved") : qsTr("Error"),
                               j.message ?? "",
                               j.status === 200 ? "success" : "danger", 3000);
        });
    }

    CTabView {
        anchors.fill: parent

        CFormView {
            id: general
            padding: 10
            rowSpacing: 30
            title: qsTr("Info")
            url: "/employee"
            keyValue: page.keyValue

            CLabel { text: qsTr("Name") }
            CIconTextField {
                leftIcon.name: "cil-user"
                objectName: "name"
                Layout.fillWidth: true
            }

            CLabel { text: qsTr("Phone") }
            CIconTextField {
                leftIcon.name: "cil-phone"
                objectName: "phone"
                Layout.fillWidth: true
            }
            CLabel { text: qsTr("Email") }
            CIconTextField {
                leftIcon.name: "cib-mail-ru"
                objectName: "email"
                Layout.fillWidth: true
            }
            CLabel { text: qsTr("Address") }
            CIconTextField {
                leftIcon.name: "cil-location-pin"
                objectName: "address_line"
                Layout.fillWidth: true
            }
        }

        CPage {
            title: qsTr("Job Titles")
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Label {
                    visible: !page.keyValue
                    Layout.fillWidth: true
                    text: qsTr("Save the employee on the Info tab first, then come back to assign job titles.")
                    wrapMode: Text.WordWrap
                    color: "#888"
                }

                ListView {
                    id: titlesList
                    visible: page.keyValue
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: page.allTitles
                    clip: true
                    spacing: 4
                    delegate: Rectangle {
                        width: titlesList.width
                        height: 44
                        color: index % 2 === 0 ? "#fafafa" : "#ffffff"
                        border.color: "#e0e0e0"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            CheckBox {
                                checked: page.isAssigned(modelData.id)
                                onToggled: page.toggleAssigned(modelData.id, checked)
                            }
                            Label {
                                text: modelData.name
                                Layout.fillWidth: true
                            }
                            Label {
                                text: qsTr("Default: ") + Utils.formatCurrency(modelData.default_salary ?? 0)
                                color: "#666"
                            }
                        }
                    }
                }

                RowLayout {
                    visible: page.keyValue
                    Layout.fillWidth: true
                    HorizontalSpacer {}
                    CButton {
                        text: qsTr("Save Job Titles")
                        palette: BrandPrimary {}
                        onClicked: page.saveAssignments()
                    }
                }
            }
        }
    }
}
