import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Buttons
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    url: "/paymentMethod"
    title: qsTr("Payment Method")
    CLabel {
        text: qsTr("Name")
    }
    CTextField {
        objectName: "name"
        Layout.fillWidth: true
    }


    CLabel {
        text: qsTr("Type")
    }
    CComboBox {
        objectName: "type"
        enabled: !initialValues
        Layout.fillWidth: true
        model: [
            {"label":qsTr("Cash"), "value": "cash"},
            {"label":qsTr("Cash on Delivery"), "value": "cod"},
            {"label":qsTr("Credit"), "value": "credit"},
            {"label":qsTr("Bank"), "value": "bank"}
        ]
        valueRole: "value"
        textRole: "label"
    }

    CLabel {
        text: qsTr("Enabled")
    }

    CCheckBox {
        text: qsTr("Enabled")
        objectName: "enabled"
        checked: true
    }



}
