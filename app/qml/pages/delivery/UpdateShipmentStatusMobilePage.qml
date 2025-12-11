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
import PosFe

CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    fetchUrl: "/shipment"
    url: "/shipment/status"
    title: qsTr("Update Shipment Status")
    CLabel {
        text: qsTr("Shipment Number:")
    }
    CNumberInput {
        objectName: "id"
        enabled: false
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Status")
    }

    CComboBox {
        id: typeCB
        objectName: "status"
        Layout.fillWidth: true
        textRole: "text"
        valueRole: "status"
        model: ListModel {
            // ListElement {
            //     text: qsTr("Manifest Created")
            //     value: "manifest_created"
            // }
            // ListElement {
            //     text: qsTr("In Transit")
            //     value: "in_transit"
            // }
            // ListElement {
            //     text: qsTr("At Local Delivery Center")
            //     value: "at_local_delivery_center"
            // }
            ListElement {
                text: qsTr("Out For Delivery")
                status: "out_for_delivery"
            }
            ListElement {
                text: qsTr("Delivered")
                status: "delivered"
            }
            ListElement {
                text: qsTr("Returned")
                status: "returned"
            }
            ListElement {
                text: qsTr("Partially Returned")
                status: "partially_returned"
            }
            // ListElement {
            //     text: qsTr("Cancelled")
            //     value: "cancelled"
            // }
        }

    }


}
