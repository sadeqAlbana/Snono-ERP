import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects

import PosFe

AppPage {
    title: qsTr("Vendors")
    padding: 10
    ColumnLayout {
        id: page
        anchors.fill: parent
        anchors.margins: 20

        AppToolBar {
            id: toolBar
            tableView: tableView
        }

        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: dialog.open()
                },
                CAction {
                    text: qsTr("Delete")
                    icon.name: "cil-delete"
                    onTriggered: tableView.removeVendor()
                }
            ]

            Popup {
                anchors.centerIn: parent
                width: 500
                height: 500



                Component.onCompleted: open();
                GridContainer {
                    id: grid
                    anchors.fill: parent
                    padding: 20
                    Form {
                        id: form
                        items: grid.contentItem.children
                    }

                    Label {text: qsTr("Name")}
                    CTextField {objectName: "name"}

                    Label {text: qsTr("Phone")}
                    CTextField {objectName: "phone"}

                    Label {text: qsTr("Email")}
                    CTextField {objectName: "email"}

                    CButton{text: qsTr("Apply"); Layout.columnSpan: 2; onClicked: console.log(JSON.stringify(form.data()))}
                }
            }

            AddVendorDialog {
                id: dialog
                onAddVendor: model.addVendor(name, email, address, phone)
            }

            function removeVendor() {
                if (tableView.selectedRow > -1) {
                    var vendorId = model.data(tableView.selectedRow, "id")
                    model.removeVendor(vendorId)
                }
            }

            model: VendorsModel {
                id: model

                onVendorAddReply: {
                    if (reply.status === 200) {
                        toastrService.push("Success", reply.message,
                                           "success", 2000)
                        model.requestData()
                    } else {
                        toastrService.push("Error", reply.message,
                                           "error", 2000)
                    }
                } //slot end

                onVendorRemoveReply: {
                    if (reply.status === 200) {
                        toastrService.push("Success", reply.message,
                                           "success", 2000)
                        model.requestData()
                    } else {
                        toastrService.push("Error", reply.message,
                                           "error", 2000)
                    }
                } //slot end
            } //model end
        }
    }

    //Component.onCompleted: newBillDlg.open();
}
