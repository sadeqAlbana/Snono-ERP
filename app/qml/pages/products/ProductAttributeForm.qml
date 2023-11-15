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
    url: "/productAttribute"
    columns: 2
    CLabel {
        text: qsTr("ID")
    }
    CTextField {
        objectName: "id"
        Layout.fillWidth: true
    }

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
        Layout.fillWidth: true
        model: [{"label":qsTr("Text"), "value": "text"},{"label":qsTr("Image"), "value": "image"}]
        valueRole: "value"
        textRole: "label"
    }

    CLabel {
        text: qsTr("Show In Filter")
    }
    CheckBox{
        objectName: "filter_visible"
    }

    CLabel {
        text: qsTr("Show In Products")
    }
    CheckBox{
        objectName: "products_visible"
    }
}
