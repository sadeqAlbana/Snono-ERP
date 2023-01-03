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

    ColumnLayout {
        id: layout
        anchors.fill: parent

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
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/vendors/VendorForm.qml")

                },
                CAction {
                    text: qsTr("Delete")
                    icon.name: "cil-delete"
                    onTriggered: tableView.removeVendor()
                }
            ]


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
}
