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
    title: qsTr("Category")
    url: "/category"


    columns: 2
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-linear"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel{
        text: qsTr("Parent Category")
    }

    CFilterComboBox{
        Layout.fillWidth: true
        objectName: "parent_id"
        textRole: "name"
        valueRole: "id"
        dataUrl: "/categories"
        defaultEntry: {"id":0,"name": qsTr("None")}
    } //
}
