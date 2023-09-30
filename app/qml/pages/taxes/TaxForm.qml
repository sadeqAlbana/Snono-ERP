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
    header.visible: true
    url: "/tax"
    columns: 2
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Type")
    }
    CComboBox {
        id: typeCB
        objectName: "type"
        Layout.fillWidth: true
        model: [{"label":qsTr("Percentage"), "value": 1},{"label":qsTr("Fixed"), "value": 2}]
        valueRole: "value"
        textRole: "label"
    }
    CLabel {
        text: qsTr("Value")
    }
    SpinBox {
        //leftIcon.name: "cil-diamond"
        objectName: "value"
        Layout.fillWidth: true
        editable: true
        to: typeCB.currentValue===1? 100 : 999999999
        from: 0
    }

    CLabel {
        text: qsTr("Account ID")
    }

    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "account_id"
        Layout.fillWidth: true
        readOnly: true
        enabled: false
    }
}
