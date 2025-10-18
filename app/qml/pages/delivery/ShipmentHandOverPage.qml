import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    url: "/shipment/handover"

    title: qsTr("Hand over Shipment")
    CLabel {
        text: qsTr("Shipment ID")
    }
    CNumberInput {
        id: barcodeInput
        objectName: "shipment_id"
        Layout.fillWidth: true

        onAccepted: {
            control.apply();
            text = ""
        }
        placeholderText: qsTr("Barcode...")
        implicitHeight: 50
    }

    Component.onCompleted: barcodeInput.forceActiveFocus();
}
