import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects
import CoreUI
import PosFe

AppPage {
    title: qsTr("Vendors")
    id: page
    StackView.onActivated: model.refresh();

    ColumnLayout {
        id: layout
        anchors.fill: parent

        AppToolBar {
            id: toolBar
            view: tableView
        }

        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/VendorForm.qml",{"applyHandler": Api.addVendor,
                                                     "title": qsTr("Add Vendor")
                                                 })

                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/VendorForm.qml",
                                                 {"applyHandler": Api.updateVendor,
                                                     "title": qsTr("Edit Vendor"),

                                                 "initialValues":model.jsonObject(tableView.currentRow)
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_vendors";

                },
                CAction {
                    text: qsTr("Delete")
                    icon.name: "cil-delete"
                    onTriggered: tableView.removeVendor();
                }
            ]


            function removeVendor() {
                if (tableView.currentRow > -1) {
                    var vendorId = model.data(tableView.currentRow, "id")
                    model.removeVendor(vendorId)
                }
            }

            model: VendorsModel {
                id: model



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
}
